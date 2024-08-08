#!../bin/python3

import argparse, pathlib, os, sys, random
import torch
from diffusers import FluxPipeline


if __name__ == "__main__":
	parser = argparse.ArgumentParser()
	parser.add_argument("--file", type=str, required=False)
	parser.add_argument("--model", type=str, required=False, default="schnell")
	parser.add_argument("--prompt", type=str, required=False, default="a goldfish inside of a goldfish bowl")
	parser.add_argument("--llm", type=str, required=False, default="none")
	parser.add_argument("--style", type=str, required=False, default="Photorealistic")
	parser.add_argument("--seed", type=int, required=False, default=0)
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
	if args.llm == "llama3":
		from ollama import Client

		if args.style == "none":
			style = "Vincent Van Gogh"
		else:
			style = str(args.style)


		if "van gogh" in style:
			prompt_modifier = f"Introduce elements of creativity and magic, introduce into the text the artistic style of {style}"
		elif "steampunk":
			prompt_modifier = f"Introduce elements of nostalgia, creativity with a twist of industrial and steampunk aesthetic"
		else:
			prompt_modifier = f"Introduce photorealistic elements and lifelike objects that would naturally fit into the scene"

		client = Client(host='http://localhost:11434', timeout = 300)
		response = client.chat(model = args.llm, keep_alive = 0, messages = [
			{
				'role': 'user',
				'content': 'Rewrite the following prompt for an image generation model. Limit the number of words in the response to no more than 50 words.' + str(prompt_modifier) + '. The prompt is: ' + prompt
			},
		])

		prompt = str(response['message']['content'])


	if args.seed == -1:
		seed = int(random.uniform(0, 5))
	else:
		seed = int(args.seed)

	print(f"\n\n[i] Generating image based on the following prompt: {prompt}\n\nMODEL={file_model} DEVICE={args.device} CPU={args.cpu} SEED={seed}")

	image = pipe(
		prompt,
		guidance_scale = 0.0,
		output_type="pil",
		num_inference_steps = 4,
		max_sequence_length = 256,
		height = args.height,
		width = args.width,
		generator = torch.Generator(args.device).manual_seed(seed)
	).images[0]
	image.save("flux-schnell.png")
