#!../bin/python3
import os, argparse

from datetime import datetime
from auralis import TTS, TTSRequest

dir_home = os.path.expanduser("~/")
dir_audio = f"{dir_home}/Audio/TTS/Auralis"


file_ts = str(int(datetime.today().timestamp()))

parser = argparse.ArgumentParser()
parser.add_argument("--voice", type = str, required = False, default = "test")
parser.add_argument("--text", type = str, required = False, default = "Some people call this artificial intelligence, but the reality is, that this technology will enhance us.")

args = parser.parse_args()

in_text = args.text

if args.voice == "test":
	in_wave = f"{dir_audio}/.voices/reference-test.wav"
	ot_wave = f"{dir_audio}/test-auralis.wav"
else:
	in_wave = f"{dir_audio}/.voices/reference.wav"
	ot_wave = f"{dir_audio}/auralis_{file_ts}.wav"




# Initialize
tts = TTS().from_pretrained("AstraMindAI/xttsv2", gpt_model = 'AstraMindAI/xtts2-gpt')

request = TTSRequest(
	text = in_text,
	speaker_files=[in_wave]
)

output = tts.generate_speech(request)
output.save(ot_wave)
