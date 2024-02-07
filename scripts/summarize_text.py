#!/usr/bin/python3
import sys, re, requests, json, time, argparse

if len(sys.argv) < 4:
	print("Usage: python summarize_text.py --model=mistral:latest --text=<path/to/file.txt> --words=1000 --prompt='summarize this text'")
	sys.exit()

def limit(s,n): return s[:n-1-(s+" ")[n-1::-1].find(" ")]

def parse_arguments():
	parser = argparse.ArgumentParser(description='Ollama text summarization')
	parser.add_argument('-m', '--model', required=True, help='For example mistral:latest')
	parser.add_argument('-t', '--text', required=True, help='Path to the text file')
	parser.add_argument('-w', '--words', required=True, help='Read the first x words of the text file')
	parser.add_argument('-p', '--prompt', default='summarize this text', help='Custom prompt for text analysis')

	return parser.parse_args()

args = parse_arguments()


with open(args.text, 'r') as file:
	string = file.read().replace('\n', '').replace('"', "'").replace(".", ". ")

input = limit(string,1000)

data = {
  "prompt": f"{args.prompt}: {input}",
  "model": f"{args.model}"
}

task_s = int(time.time())
response = requests.post("http://localhost:11434/api/generate", json=data, stream=True)

output = ""
for line in response.iter_lines():
	if line:
		json_data = json.loads(line)
		if json_data['done'] == False:
			generated = json_data['response']
			output += generated
			print(generated, end='', flush=True)

with open(f'{args.text}_summary.txt', 'w', encoding='utf-8') as f:
	f.write(output)

task_e = int(time.time())
task_t = task_e - task_s



print(f"\n\n[i] Task took: {task_t}s")
