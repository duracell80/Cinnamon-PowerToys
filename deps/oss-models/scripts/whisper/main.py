#!../bin/python3

import argparse, pathlib, time, sys, os, pysubs2
from faster_whisper import WhisperModel

import ollama


if __name__ == "__main__":
	parser = argparse.ArgumentParser()
	parser.add_argument("--file", type=str, required=True)
	parser.add_argument("--model", type=str, required=True)
	parser.add_argument("--cpu", action="store_true")

	args = parser.parse_args()

	file_path = pathlib.Path(args.file).parent
	file_name = pathlib.Path(args.file).name
	file_extension = pathlib.Path(args.file).suffix

	file_path_mp3 = f"{file_path}/{str(file_name).replace(file_extension, '.mp3')}"
	file_path_srt = f"{file_path}/{str(file_name).replace(file_extension, '.srt')}"
	file_path_ass = f"{file_path}/{str(file_name).replace(file_extension, '.ass')}"
	file_path_txt = f"{file_path}/{str(file_name).replace(file_extension, '.txt')}"
	file_path_mkd = f"{file_path}/{str(file_name).replace(file_extension, '.md')}"
	file_summ_txt = f"{file_path}/{str(file_name).replace(file_extension, '_summary.txt')}"

	model_size = f"{args.model}"


	if os.path.isfile(file_path_srt) == False:
		try:
			if args.cpu:
				model = WhisperModel(model_size, device="cpu", compute_type="int8")
			else:
				model = WhisperModel(model_size, device="cuda", compute_type="float16")
		except:
			print(f"[i] Loading Whisper failed, exiting without transcribing :(")
			sys.exit()

		start_time = time.time()
		print(f"[i] Generating transcription of file: {args.file}")

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

		subs.save(f"{str(file_path_srt)}")
		subs.save(f"{str(file_path_ass)}")

		os.popen(f"cp {file_path_srt} {file_path_mkd}")

		transcription_file = f"{file_path_txt}"
		summary_file = f"{file_summ_txt}"

		end_time = time.time()
		total_time = round(end_time - start_time)

		with open(transcription_file, "w") as file:
			file.write(f"{str(paras).replace('. .', '.')}")

		file = open(f"{transcription_file}")

		contents = file.read()
		file.close()

		print(f"[i] Generating summary of file: {transcription_file}")
		response = ollama.chat(model = 'llama3', keep_alive = 0, timeout = 600, messages = [
			{
				'role': 'user',
				'content': 'This text is a transcription. Please summerize the text, giving a section of bullet points as a key takeaways section at the end of the summary. Produce 5 tags of keywords found in the article and present these with a hashtag. Provide output in markdown format. The transcription is as follows: ' + str(contents),
			},
		])
		summary = str(response['message']['content'])
		#summary = ollama.generate(model='llama3', prompt='Summerize the following text: ' + str(contents))
		print(summary)


		with open(summary_file, "w") as file:
			file.write(f"{summary} \n\n> [!NOTE] Notes\n> Contents \n\n![[{str(file_name).replace(file_extension, '.mp3')}]]")

		print(f"[i] Task took: {total_time}s")
	else:
		print("[!] Subtitle SRT filenot found")
