#!../bin/python3

import argparse, pathlib, os, sys
from ollama import Client


if __name__ == "__main__":
	parser = argparse.ArgumentParser()
	parser.add_argument("--file", type=str, required=True)
	parser.add_argument("--prompt", type=str, required=False, default="in no more than 50 words describe how the story telling elements of this image could be improved")

	args = parser.parse_args()


	client = Client(host='http://localhost:11434', timeout = 300)

	with open(args.file, 'rb') as file:
		critic = client.chat(
		keep_alive = 0,
		model='llava',
			messages=[
				{
					'role': 'user',
					'content': args.prompt,
					'images': [file.read()],
				},
			],
		)

		response = client.chat(model = 'llama3', keep_alive = 0, messages = [
			{
				'role': 'user',
				'content': 'Creatively write a prompt for an image generation model based on this text. Limit the number of words in the response to no more than 50 words, do not give a word count or explain what the text is. The text is: ' + str(critic['message']['content'])
			},
		])

		print(response['message']['content'].replace('"', ''))
