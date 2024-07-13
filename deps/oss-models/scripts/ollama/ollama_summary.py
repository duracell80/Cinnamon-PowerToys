#!/usr/bin/python3

import os, pathlib, argparse, time

from ollama import Client

if __name__ == "__main__":
	parser = argparse.ArgumentParser()
	parser.add_argument("--file", type=str, required=True)
	parser.add_argument("--model", type=str, default="llama3", required=False)
	parser.add_argument("--prompt", type=str, default="Please summarize the text, giving a section of bullet points as a key takeaways section at the end of the summary.", required=False)
	parser.add_argument("--context", type=str, default="transcription", required=False)
	parser.add_argument('--no-gpu', default=True, required=False, action=argparse.BooleanOptionalAction)

	# args.context = "transcription"

	args = parser.parse_args()

	if args.context:
		param_context = args.context
	else:
		param_context = "transcription"


	if args.prompt:
		param_prompt = args.prompt
	else:
		param_prompt = "Please summarize the text, giving a section of bullet points as a key takeaways section at the end of the summary. Give me a rating between 1 and 10 of how interesting this text is. Provide output in markdown format where possible"


	file_path = pathlib.Path(args.file).parent
	file_name = pathlib.Path(args.file).name
	file_extension = pathlib.Path(args.file).suffix

	file_path_txt = f"{file_path}/{str(file_name).replace(file_extension, '.txt')}"
	file_path_sum = f"{file_path}/{str(file_name).replace(file_extension, '_summary.txt')}"

	file_txt = open(file_path_txt)
	file_txt_contents = file_txt.read()
	file_txt.close()


	start_time = time.time()

	print(f"[i] Generating summary of file: {file_name}")

	client = Client(host='http://localhost:11434', timeout = 300)
	response = client.chat(model = args.model, keep_alive = 0, messages = [
		{
			'role': 'user',
			'content': 'This text is a ' + param_context + '. ' + param_prompt + '. The ' + param_context + ' is as follows: ' + file_txt_contents
		},
	])

	summary1 = str(response['message']['content'])

	response2 = client.chat(model = args.model, keep_alive = 0, messages = [
		{
			'role': 'user',
			'content': 'This text is a summary of a ' + param_context +'. Please give a list of 5 keywords from the text as hashtags with a poundsign at the start of each word. The ' + param_context + ' is as follows: ' + summary1
		},
	])

	summary2 = str(response2['message']['content'])

	summary = f"{summary1}\n\n{summary2}"

	print(summary)


	with open(file_path_sum, "w") as file:
		file.write(f"{summary}")

	end_time = time.time()
	total_time = round(end_time - start_time)

	print(f"[i] Summarization task took: {total_time}s")

