#!../bin/python3

import argparse, time
from faster_whisper import WhisperModel


if __name__ == "__main__":
	parser = argparse.ArgumentParser()
	parser.add_argument("--audio", type=str, required=True)
	parser.add_argument("--model", type=str, required=True)
	parser.add_argument("--cpu", action="store_true")

	args = parser.parse_args()




	model_size = f"{args.model}"
	if args.cpu:
		model = WhisperModel(model_size, device="cpu", compute_type="int8")
	else:
		model = WhisperModel(model_size, device="cuda", compute_type="float16")

	start_time = time.time()
	segments, info = model.transcribe(f"{args.audio}", beam_size=5)

	print("Detected language '%s' with probability %f" % (info.language, info.language_probability))

	for segment in segments:
		print("[%.2fs -> %.2fs] %s" % (segment.start, segment.end, segment.text))

	total_time = time.time() - start_time
	print(f"[i] Task took {round(total_time)}s")
