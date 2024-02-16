#!../bin/python3

import scipy, time
from transformers import AutoProcessor, BarkModel


processor = AutoProcessor.from_pretrained("suno/bark")
model = BarkModel.from_pretrained("suno/bark")

voice_preset = "v2/en_speaker_6"

inputs = processor("Severe thunderstorm warning in effect for Davidson County until 4 29 pm", voice_preset=voice_preset)

audio_array = model.generate(**inputs)
audio_array = audio_array.cpu().numpy().squeeze()

sample_rate = model.generation_config.sample_rate
scipy.io.wavfile.write(f"/tmp/bark_test.wav", rate=sample_rate, data=audio_array)
