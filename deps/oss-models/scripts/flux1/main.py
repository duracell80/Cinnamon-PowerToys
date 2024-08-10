#!../bin/python3

import argparse, pathlib, os, sys, random, time
import torch
from diffusers import FluxPipeline


if __name__ == "__main__":
	parser = argparse.ArgumentParser()
	parser.add_argument("--file", type=str, required=False)
	parser.add_argument("--model", type=str, required=False, default="schnell")
	parser.add_argument("--prompt", type=str, required=False, default="A young woman wearing a straw hat wading through a corn field")
	parser.add_argument("--rewrite", type=str, required=False, default="norewrite")
	parser.add_argument("--style", type=str, required=False, default="photorealistic")
	parser.add_argument("--seed", type=int, required=False, default=0)
	parser.add_argument("--steps", type=int, required=False, default=4)
	parser.add_argument("--angle", type=str, required=False, default="close up")
	parser.add_argument("--height", type=int, required=False, default=1080)
	parser.add_argument("--width", type=int, required=False, default=1920)
	parser.add_argument("--cpu", type=str, required=False, default="sequential")
	parser.add_argument("--device", type=str, required=False, default="cpu")

	prompt_max_words = 53
	prompt_modifier = "reuse"
	style="reuse"

	args = parser.parse_args()

	file_model = str(args.model)

	prompt = f"Create {args.prompt}"
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


	pipe = FluxPipeline.from_pretrained(f"black-forest-labs/FLUX.1-{file_model}", torch_dtype=torch.bfloat16)

	if args.cpu == "sequential":
		pipe.enable_sequential_cpu_offload()
	elif args.cpu == "offload":
		pipe.enable_model_cpu_offload()

	if args.seed <= 0:
		seed = int(random.uniform(1, 1000000))
	else:
		seed = int(args.seed)

	if args.steps <= 0 or args.steps >= 50:
		steps = int(random.uniform(4, 30))
	else:
		steps = int(args.steps)


	if steps > 25:
		step_scale = random.uniform(0.5, 7.0)
	else:
		step_scale = 0


	prompt_seqlen = 256



	# Enhance prompt with LLM
	prompt_original = prompt
	if args.rewrite == "reuse" or args.rewrite == "lock" or args.rewrite == "keep":
		file = open(os.path.expanduser("~/") + "/.cache/fluxprompt.txt", "r")
		prompt = file.read()
		file.close()

	elif "llama" in args.rewrite or "mistral" in args.rewrite or args.rewrite == "llm":
		from ollama import Client

		if args.style == "none":
			style = "Vincent Van Gogh"
		else:
			style = str(args.style)


		if "van gogh" in style:
			prompt_modifier = f"Introduce elements of creativity and magic, introduce into the text the artistic style of {style}"
		elif "steampunk" in style:
			prompt_modifier = f"Introduce elements of nostalgia, creativity with a twist of industrial and steampunk aesthetic"
		elif "hollywood-action" in style:
			prompt_modifier = f"The image should be in the style of a hollywood action movie scene"
		elif "hollywood-romance" in style:
			prompt_modifier = f"The image should be in the style of a romantic comedy or rom-com movie scene"
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

		f = open(os.path.expanduser("~/") + "/.cache/fluxprompt.txt", "w")
		f.write(str(prompt))
		f.close()


	print(f"\n\n[i] Generating image based on the following prompt:\n\n{prompt}\n\nMODEL={str(file_model).upper()} DEVICE={str(args.device).upper()} CPU={str(args.cpu).upper()} SEED={seed} STEPS={steps}")

	time_start = int(time.time())
	file_name = f"flux-{time_start}__se{seed}-st{steps}"

	image = pipe(
		prompt = prompt,
		guidance_scale = step_scale,
		output_type="pil",
		num_inference_steps = steps,
		max_sequence_length = prompt_seqlen, # cannot be more than 256
		height = args.height,
		width = args.width,
		generator = torch.Generator(args.device).manual_seed(seed)
	).images[0]

	time_end = int(time.time() - time_start)

	image.save(f"{file_name}.png")


	f = open(f"{file_name}.txt", "w")
	f.write(f"Prompt Original: {prompt_original} (modifier: {str(prompt_modifier)})\nPrompt Modified: {str(prompt)} \n\nparams:model={file_model}-{args.rewrite},style={style},seed={seed},steps={steps},guidance_scale={step_scale},device={args.device},cpu={args.cpu},height={args.height},width={args.width},generationseconds={str(time_end)},generatedat={str(time_start)}")
	f.close()

	print(f"[i] DONE, task took {time_end}s")
