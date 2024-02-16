#!../bin/python3

import scipy, time, pathlib, argparse, sys
from transformers import AutoProcessor, BarkModel


if __name__ == "__main__":
	parser = argparse.ArgumentParser()
	parser.add_argument("--file", type=str, required=True, help='Path to text file with short sentences of about 12 words')
	parser.add_argument("--voice", type=str, required=True, help='A voice model for example: en_speaker_6')
	parser.add_argument("--cpu", action="store_true")

	args = parser.parse_args()

	ts = int(time.time())

	file_path = pathlib.Path(args.file).parent
	file_name = pathlib.Path(args.file).name
	file_ext = pathlib.Path(args.file).suffix


	processor = AutoProcessor.from_pretrained("suno/bark")
	model = BarkModel.from_pretrained("suno/bark")


	c = 0
	with open(args.file) as file:
		for line in file:

			words = str(line.rstrip())
			if len(words) > 0:
				c += 1
				print(f"Transforming Line {c} to speech ... '{words}'")
				print(str(c * 2))

				inputs = processor(words, voice_preset = f"v2/{args.voice}")

				audio_array = model.generate(**inputs)
				audio_array = audio_array.cpu().numpy().squeeze()
				sample_rate = model.generation_config.sample_rate

				if "bark_test" in file_name:
					file_wav = "/tmp/bark_test.wav"
				else:
					file_wav = f"{file_path}/{str(file_name).replace(file_ext, '_' + str(c) + '-' + str(ts) + '.wav')}"

				scipy.io.wavfile.write(f"{file_wav}", rate=sample_rate, data=audio_array)
