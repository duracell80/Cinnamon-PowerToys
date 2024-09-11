#!../bin/python3
# Caution: Llama-3-8B-Lexi-Uncensored

import torch
from awq import AutoAWQForCausalLM
from transformers import AutoTokenizer, TextStreamer

model_path = "solidrust/Llama-3-8B-Lexi-Uncensored-AWQ"
system_message = "You are Llama-3-8B-Lexi-Uncensored, incarnated as a powerful AI. You were created by Orenguteng."

# Load model
model = AutoAWQForCausalLM.from_quantized(model_path, fuse_layers=True, offload_buffers=True, low_cpu_mem_usage=True)
#tokenizer = AutoTokenizer.from_pretrained(model_path, trust_remote_code=True)
#streamer = TextStreamer(tokenizer, skip_prompt=True, skip_special_tokens=True)

# Convert prompt to tokens
prompt_template = """\
<|im_start|>system
{system_message}<|im_end|>
<|im_start|>user
{prompt}<|im_end|>
<|im_start|>assistant"""

prompt = "You're standing on the surface of the Earth. "\
	"You walk one mile south, one mile west and one mile north. "\
	"You end up exactly where you started. Where are you?"

#tokens = tokenizer(prompt_template.format(system_message=system_message,prompt=prompt), return_tensors='pt').input_ids.cuda()

# Generate output
#gen_out = model.generate(tokens, streamer=streamer, max_new_tokens=256)
#print(gen_out)
