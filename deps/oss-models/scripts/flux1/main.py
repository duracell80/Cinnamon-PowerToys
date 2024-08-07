#!../bin/python3

import torch
from diffusers import FluxPipeline

pipe = FluxPipeline.from_pretrained("black-forest-labs/FLUX.1-schnell", torch_dtype=torch.bfloat16)
#pipe.enable_model_cpu_offload() #save some VRAM by offloading the model to CPU. Remove this if you have enough GPU power
pipe.enable_sequential_cpu_offload()

prompt = "A wideshot of a scenic view of whistler lakes"
seed = 0
image = pipe(
	prompt,
	guidance_scale=0.0,
	output_type="pil",
	num_inference_steps=4,
	max_sequence_length=256,
	height=1080,
	width=1920,
	generator=torch.Generator("cpu").manual_seed(seed)
).images[0]
image.save("flux-schnell.png")
