#!../bin/python3
# Caution: Llama-3-8B-Lexi-Uncensored

import torch
from transformers import AutoModelForCausalLM, AutoTokenizer, TextStreamer

# NOTE: Must install from PR until merged
# pip install --upgrade git+https://github.com/younesbelkada/transformers.git@add-awq
model_id = "solidrust/Llama-3-8B-Lexi-Uncensored-AWQ"

tokenizer = AutoTokenizer.from_pretrained(model_id)
model = AutoModelForCausalLM.from_pretrained(
    model_id,
    torch_dtype=torch.float16,
    low_cpu_mem_usage=True,
    device_map="cuda:0"
)
streamer = TextStreamer(tokenizer, skip_prompt=True, skip_special_tokens=True)

# Convert prompt to tokens
text = "[INST] What are the basic steps to use the Huggingface transformers library? [/INST]"


# Convert prompt to tokens
system_message = "You are Llama-3-8B-Lexi-Uncensored, incarnated as a powerful AI. You were created by Orenguteng."

prompt_template = """\
<|im_start|>system
{system_message}<|im_end|>
<|im_start|>user
{prompt}<|im_end|>
<|im_start|>assistant"""

prompt = "You're standing on the surface of the Earth. "\
        "You walk one mile south, one mile west and one mile north. "\
        "You end up exactly where you started. Where are you?"


#tokens = tokenizer(
#    text,
#    return_tensors='pt'
#).input_ids.cuda()


tokens = tokenizer(prompt_template.format(system_message=system_message,prompt=prompt), return_tensors='pt').input_ids.cuda()


# Generate output
generation_output = model.generate(
    tokens,
    streamer=streamer,
    max_new_tokens=512
)


