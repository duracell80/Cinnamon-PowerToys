#!../bin/python3

import argparse, time, pysubs2
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
	segments, _ = model.transcribe(audio=f"{args.audio}", beam_size=5)

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
	if ".mp3" in args.audio:
		subs.save(f"{str(args.audio).replace('.mp3', '.srt')}")
		subs.save(f"{str(args.audio).replace('.mp3', '.ass')}")
	elif ".wav" in args.audio:
		subs.save(f"{str(args.audio).replace('.wav', '.srt')}")
		subs.save(f"{str(args.audio).replace('.wav', '.ass')}")

	end_time = time.time()
	total_time = round(end_time - start_time)

	with open(f"{args.audio}.txt", "w") as file:
		file.write(f"{str(paras).replace('. .', '.')}")

	print(f"[i] Task took: {total_time}s")
