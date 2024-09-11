#!../bin/python3
# Caution: Llama-3-8B-Lexi-Uncensored

from transformers import pipeline

messages = [
    {"role": "user", "content": "Who are you?"},
]
pipe = pipeline("text-generation", model="Orenguteng/Llama-3-8B-Lexi-Uncensored", device="cuda")
#pipe.enable_sequential_cpu_offload()
pipe.enable_model_cpu_offload()

pipe(messages)
