#!../bin/python3

import argparse, pathlib, os, sys, random, time, exif, sqlite3, base64, uuid
import torch

from diffusers import FluxPipeline

from PIL import Image
from PIL import ExifTags
from exif import Image as ExifImage


def png2jpg(filename, metadata):
	dir_home = os.path.expanduser("~/")

	png_img = Image.open(f"images/{filename}")
	jpg_img = png_img.convert("RGB")

	dem_img = Image.open("images/demo.jpg")
	img_exif = dem_img.getexif()
	img_desc = f"{metadata[4]} (steps={metadata[1]},seed={metadata[2]},guidance={metadata[3]},cpu={metadata[9]},angle={metadata[6]},style={metadata[5]},model={metadata[7]}-{metadata[8]})"

	PILLOW_TAGS = [
		315,     # Artist Name
		33432,   # Copyright Message
		270,	 # Description
	]

	EXIF_TAGS = [
		"artist",
		"copyright",
		"description",
	]

	VALUES = [
		"Flux1",    # Artist Name
		"Black Forest Labs (NoRobots,AntiSLOP).",  # Copyright Message
		str(img_desc) # Description
	]

	for tag, value in zip(PILLOW_TAGS, VALUES):
		img_exif[tag] = value

	jpg_img.save(f"images/{str(filename.split('.')[0])}.jpg", exif = img_exif)
	os.rename(f"images/{str(file_name)}.jpg", f"{dir_home}/Pictures/Flux1/{str(file_name)}.jpg")



def img2bin(filename):
	png_img = Image.open(filename)
	jpg_img = png_img.convert("RGB")

	half = 0.5
	out_img = jpg_img.resize( [int(half * s) for s in png_img.size] )

	out_img.save("images/store.jpg")

	with open("images/store.jpg", 'rb') as file:
		blobData = file.read()

	with open("images/store.blob", "wb") as bfile:
		bfile.write(base64.b64encode(blobData))

	os.remove("images/store.jpg")

	return blobData



def add_generation(conn, values):

	sql = ''' INSERT INTO generations (uuid, timestamp, timetogen, modelvar, chip, offload, gpuinfo, seed, steps, height, width, style, angle, prompt, prompt_rewriter, prompt_modifier, prompt_modified, prompt_sequence, prompt_guidance, prompt_negative, image_thumbnail)
		VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?) '''

	curr = conn.cursor()
	curr.execute(sql, values)
	conn.commit()

	print(f"\n\n[i] DB INSERT: Created a generation record\n\n")




if __name__ == "__main__":
	parser = argparse.ArgumentParser()
	parser.add_argument("--file", type=str, required=False)
	parser.add_argument("--model", type=str, required=False, default="schnell")
	parser.add_argument("--prompt", type=str, required=False, default="A young woman wearing a straw hat wading through a corn field")
	parser.add_argument("--rewrite", type=str, required=False, default="norewrite")
	parser.add_argument("--style", type=str, required=False, default="photorealistic")
	parser.add_argument("--seed", type=int, required=False, default=0)
	parser.add_argument("--steps", type=int, required=False, default=5)
	parser.add_argument("--guidance", type=float, required=False, default=5.1)
	parser.add_argument("--angle", type=str, required=False, default="close up")
	parser.add_argument("--reseed", type=int, required=False, default=0)
	parser.add_argument("--height", type=int, required=False, default=1080)
	parser.add_argument("--width", type=int, required=False, default=1920)
	parser.add_argument("--cpu", type=str, required=False, default="sequential")
	parser.add_argument("--device", type=str, required=False, default="cpu")

	args = parser.parse_args()

	prompt_max_words = 53
	prompt_modifier = "reuse"

	if args.style == "none" or args.style == "":
		style = "photorealistic"
	else:
		style = str(args.style).lower()


	file_model = str(args.model)
	device_cuda = "nvidia-rtx-3050-6gb"

	prompt = f"{args.prompt}"
	prompt_enhanced = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum. It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using 'Content here, content here', making it look like readable English. Many desktop publishing packages and web page editors now use Lorem Ipsum as their default model text, and a search for 'lorem ipsum' will uncover many web sites still in their infancy. Various versions have evolved over the years, sometimes by accident, sometimes on purpose (injected humour and the like)"

	if len(prompt.split(" ")) > prompt_max_words and args.rewrite == "norewrite":
		print(f"\n\n[!] Prompt too long, try a shorter prompt with less than {prompt_max_words} words.\n\n")
		sys.exit()

	if args.file:
		file_path = pathlib.Path(args.file).parent
		file_name = pathlib.Path(args.file).name
		file_extension = pathlib.Path(args.file).suffix

	#if args.model == "dev":
		#from huggingface_hub import login
		#login(token = 'my token')


	if args.seed <= 0:
		seed = int(random.uniform(1, 10000000000))
	else:
		seed = int(args.seed)

	if args.steps <= 0 or args.steps >= 50:
		steps = int(random.uniform(4, 30))
	else:
		steps = int(args.steps)

	# Try different seeds with same parameters max 50 (iterate with different starting points)
	if args.reseed > 50:
		reseed = int(random.uniform(0, 50))
	elif args.reseed < 0:
		reseed = 0
	else:
		reseed = int(args.reseed)

	#if steps > 25:
	#	step_scale = random.uniform(0.5, 7.0)
	#else:
	#	step_scale = 0

	if "schnell" in args.model:
		guidance = 0
		prompt_seqlen = 256
	else:
		if args.guidance <= 0 or args.guidance > 20:
			guidance = round(random.uniform(0.1, 20.0), 2)
		else:
			guidance = round(args.guidance, 2)

		prompt_seqlen = 512



	# Enhance prompt with LLM
	prompt_original = prompt
	prompt_modifier = ""
	if args.rewrite == "reuse" or args.rewrite == "lock" or args.rewrite == "keep":
		file = open(os.path.expanduser("~/") + "/.cache/fluxprompt.txt", "r")
		prompt = file.read()
		file.close()

	elif "llama" in args.rewrite or "mistral" in args.rewrite or args.rewrite == "llm":
		from ollama import Client

		if "van-gogh" in style:
			prompt_modifier = f"All of the elements are in the swirling and watery artistic style of Vincent Van Gogh"
			guidance = 0
		elif "water-paint" in style:
			prompt_modifier = f"The image is in the artistic style of impressionist painting and is painted on canvas in watery hues"
			guidance = 0.1
		elif "steampunk" in style:
			prompt_modifier = f"Introduce elements of nostalgia, creativity with a twist of industrial and steampunk aesthetic"
		elif "hollywood-action" in style:
			prompt_modifier = f"The image should be in the style of a hollywood action movie scene"
		elif "hollywood-romance" in style:
			prompt_modifier = f"The image should be in the style of a romantic movie scene"
		elif "anime-cute" in style:
			prompt_modifier = f"Make the image in the style of a cute japanese anime cartoon"
		elif "anime-action" in style:
			prompt_modifier = f"Make the image in the style of an intense japanese anime action scene"
		elif "funko" in style:
			prompt_modifier = f"Turn the people and animals in the scene into funko pop characters"
		else:
			prompt_modifier = f"Introduce photorealistic elements and lifelike objects that would naturally fit into the scene"


		if "close-up" in args.angle:
			prompt_modifier = f"{prompt_modifier}. The camera angle is a {args.angle} shot, with a lot of background blurring and bokeh"
		elif "long-shot" in args.angle:
			prompt_modifier = f"{prompt_modifier}. The camera angle is a long shot with some mild background blurring, the subject is not too distant"
		elif "wide" in args.angle:
			prompt_modifier = f"{prompt_modifier}. The camera angle is a {args.angle} shot showing the background unblurred"
		elif "ultra-wide" in args.angle:
			prompt_modifier = f"{prompt_modifier}. The image is taken from a distance showing the subject quite small in the frame and lots of details in the background"



		try:
			while len(str(prompt_enhanced).split(" ")) > prompt_max_words:
				client = Client(host='http://localhost:11434', timeout = 300)
				response = client.chat(model = args.rewrite, keep_alive = 0, messages = [
					{
						'role': 'user',
						'content': 'Creatively rewrite the following prompt for an image generation model. Limit the number of words in the response to no more than ' + str(prompt_max_words) + ' words. Do not introduce the text or explain how the text was rewritten. The prompt is: ' + prompt + '. ' + str(prompt_modifier)
					},
				])
				prompt_enhanced = str(response['message']['content']).replace('"', '')
			prompt = prompt_enhanced
		except:
			prompt = f"{prompt}. {prompt_modifier}"

		f = open(os.path.expanduser("~/") + "/.cache/fluxprompt.txt", "w")
		f.write(str(prompt))
		f.close()


	print(f"\n\n[i] Generating image(s) based on the following prompt:\n\n[i]PROMPT: {prompt}\n\nMODEL={str(file_model).upper()} DEVICE={str(args.device).upper()} CPU={str(args.cpu).upper()} SEED={seed} STEPS={steps} GUIDANCE={guidance} STYLE={style}\n\n")

	conn = sqlite3.connect("data.db")


	pipe = FluxPipeline.from_pretrained(f"black-forest-labs/FLUX.1-{file_model}", torch_dtype=torch.bfloat16)

	if args.cpu == "sequential":
		pipe.enable_sequential_cpu_offload()
	elif args.cpu == "offload":
		pipe.enable_model_cpu_offload()

	iteration = 0

	while iteration <= reseed:
		time_start = int(time.time())

		if iteration >= 1:
			seed = int(random.uniform(1, 10000000000))
			print(f"[i] RESEEDING: {str(iteration)} of {reseed} (seed={seed},steps={steps},guidance={int(guidance)},style={style},timestamp={time_start})\n\n[i] PROMPT: {str(prompt)}\n\n")

		file_name = f"flux-{time_start}__se{seed}-st{steps}-gu{int(guidance)}"
		meta_data = []

		meta_data.append(str(time_start))
		meta_data.append(str(seed))
		meta_data.append(str(steps))
		meta_data.append(str(guidance))
		meta_data.append(f"{str(prompt)} (Base prompt: {str(prompt_original)})")
		meta_data.append(str(style))
		meta_data.append(str(args.angle))
		meta_data.append(str(args.model))
		meta_data.append(str(args.rewrite))
		meta_data.append(str(args.cpu))

		image = pipe(
			prompt = prompt,
			guidance_scale = guidance,
			output_type="pil",
			num_inference_steps = steps,
			max_sequence_length = prompt_seqlen, # cannot be more than 256 with lowest model
			height = args.height,
			width = args.width,
			generator = torch.Generator(args.device).manual_seed(seed)
		).images[0]

		time_end = int(time.time() - time_start)

		image.save(f"images/{file_name}.png")
		png2jpg(f"{file_name}.png", meta_data)

		f = open(f"images/.meta/{file_name}.txt", "w")
		f.write(f"Prompt Original: {prompt_original} (modifier: {str(prompt_modifier)})\nPrompt Modified: {str(prompt)} \n\nparams:model={file_model}-{args.rewrite},style={style},seed={seed},steps={steps},guidance_scale={guidance},device={args.device},cpu={args.cpu},height={args.height},width={args.width},generationseconds={str(time_end)},generatedat={str(time_start)}")
		f.close()


		generations = [
        		(str(uuid.uuid4()), meta_data[0], time_end, meta_data[7], "cuda", meta_data[9], str(device_cuda), meta_data[1], meta_data[2], int(args.height), int(args.width), meta_data[5], meta_data[6], str(prompt_original), meta_data[8], str(prompt_modifier), str(prompt), int(prompt_seqlen), meta_data[3], "No negative prompt", img2bin(f"images/{file_name}.png")),
		]

		for generation in generations:
			add_generation(conn, generation)

		iteration += 1
		print(f"[i] DONE, task took {time_end}s")

	conn.close()
