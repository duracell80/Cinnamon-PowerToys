#!../bin/python3

import argparse, pathlib, os, sys, random, time
import torch
from diffusers import FluxPipeline


if __name__ == "__main__":
	parser = argparse.ArgumentParser()
	parser.add_argument("--file", type=str, required=False)
	parser.add_argument("--model", type=str, required=False, default="schnell")
	parser.add_argument("--prompt", type=str, required=False, default="a goldfish inside of a goldfish bowl")
	parser.add_argument("--llm", type=str, required=False, default="norewrite")
	parser.add_argument("--style", type=str, required=False, default="photorealistic")
	parser.add_argument("--seed", type=int, required=False, default=0)
	parser.add_argument("--steps", type=int, required=False, default=4)
	parser.add_argument("--angle", type=str, required=False, default="close up")
	parser.add_argument("--height", type=int, required=False, default=1080)
	parser.add_argument("--width", type=int, required=False, default=1920)
	parser.add_argument("--cpu", type=str, required=False, default="sequential")
	parser.add_argument("--device", type=str, required=False, default="cpu")

	args = parser.parse_args()

	file_model = str(args.model)

	prompt = f"Create {args.prompt}"

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

	# Enhance prompt with LLM
	prompt_original = prompt
	if args.llm == "llama3":
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
		else:
			prompt_modifier = f"Introduce photorealistic elements and lifelike objects that would naturally fit into the scene"


		if "close-up" in args.angle:
			prompt_modifier = f"{prompt_modifier}. The camera angle is a {args.angle} shot, with a lot of background blurring and bokeh."
		elif "long-shot" in args.angle:
			prompt_modifier = f"{prompt_modifier}. The camera angle is a long shot with some mild background blurring, the subject is not too distant."
		elif "wide" in args.angle:
			prompt_modifier = f"{prompt_modifier}. The camera angle is a {args.angle} shot showing the background unblurred."
		elif "ultra-wide" in args.angle:
			prompt_modifier = f"{prompt_modifier}. The image is taken from a distance showing the subject quite small in the frame and lots of details in the background."

		client = Client(host='http://localhost:11434', timeout = 300)
		response = client.chat(model = args.llm, keep_alive = 0, messages = [
			{
				'role': 'user',
				'content': 'Rewrite the following prompt for an image generation model. Limit the number of words in the response to no more than 50 words.' + str(prompt_modifier) + '. Do not explain what the text is. The prompt is: ' + prompt
			},
		])
		prompt = str(response['message']['content'])


	if args.seed <= 0:
		seed = int(random.uniform(1, 100))
	else:
		seed = int(args.seed)

	if args.steps <= 0 or args.steps >= 25:
		steps = int(random.uniform(1, 10))
	else:
		steps = int(args.steps)

	print(f"\n\n[i] Generating image based on the following prompt:\n\n {prompt}\n\nMODEL={str(file_model).upper()} DEVICE={str(args.device).upper()} CPU={str(args.cpu).upper()} SEED={seed} STEPS={steps}")

	time_start = int(time.time())
	file_name = f"flux-{time_start}__se{seed}-st{steps}"

	image = pipe(
		prompt,
		guidance_scale = 0.0,
		output_type="pil",
		num_inference_steps = steps,
		max_sequence_length = 256,
		height = args.height,
		width = args.width,
		generator = torch.Generator(args.device).manual_seed(seed)
	).images[0]

	time_end = int(time.time() - time_start)

	image.save(f"{file_name}.png")


	f = open(f"{file_name}.txt", "w")
	f.write(f"Prompt Original: {prompt_original} (modifier: {str(prompt_modifier)})\nPrompt Modified: {str(prompt)} \n\nparams:model={file_model}-{args.llm},style={style},seed={seed},steps={steps},device={args.device},cpu={args.cpu},height={args.height},width={args.width},generationseconds={str(time_end)},generatedat={str(time_start)}")
	f.close()

	print(f"[i] DONE, task took {time_end}s")
