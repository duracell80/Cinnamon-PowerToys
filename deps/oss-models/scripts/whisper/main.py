#!../bin/python3

import argparse, pathlib, time, sys, pysubs2
from faster_whisper import WhisperModel


if __name__ == "__main__":
	parser = argparse.ArgumentParser()
	parser.add_argument("--file", type=str, required=True)
	parser.add_argument("--model", type=str, required=True)
	parser.add_argument("--cpu", action="store_true")

	args = parser.parse_args()

	file_extension = pathlib.Path(args.file).suffix
	model_size = f"{args.model}"

	if args.cpu:
		model = WhisperModel(model_size, device="cpu", compute_type="int8")
	else:
		model = WhisperModel(model_size, device="cuda", compute_type="float16")

	start_time = time.time()
	segments, _ = model.transcribe(audio=f"{args.file}", beam_size=5)

	results = []
	result = ""

	for i,s in enumerate(segments):
		result += f"{s.text}"

		segment_dict = {'start':s.start,'end':s.end,'text':s.text}
		results.append(segment_dict)

	block = result.split(".")
	paras = ""
	for i,p in enumerate(block):
		if i % 5 == 0:
        		paras += str(f"{p}.\n\n").lstrip(" ")
		else:
			paras += str(f"{p}. ").lstrip(" ")


	subs = pysubs2.load_from_whisper(results)

	subs.save(f"{str(args.file).replace(file_extension, '.srt')}")
	subs.save(f"{str(args.file).replace(file_extension, '.ass')}")

	transcription_file = str(args.file).replace(file_extension, '.txt')

	end_time = time.time()
	total_time = round(end_time - start_time)

	with open(transcription_file, "w") as file:
		file.write(f"{str(paras).replace('. .', '.')}")

	print(f"[i] Task took: {total_time}s")
