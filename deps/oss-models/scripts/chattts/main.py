#!../bin/python3

import ChatTTS
import torch, torchaudio
import os, sys, argparse

dir_home = os.path.expanduser("~/")



if __name__ == "__main__":
	parser = argparse.ArgumentParser()
	parser.add_argument("--text", type=str, default="/tmp/chattts.txt", required=False)
	parser.add_argument("--voice", type=str, default="1", required=True)
	parser.add_argument("--gender", type=str, default="f", required=True)

	args = parser.parse_args()

	if args.gender == "f" or args.gender == "m" or args.gender == "t":
		param_gender = str(args.gender)
	else:
		param_gender = "f"

	if os.path.isfile(args.text) and ".txt" in args.text:
		param_file = args.text
		with open('data.txt', 'r') as file:
			param_text = param_file.read().replace('\n', '')
	else:
		param_text = args.text

	print(param_gender)
	with open(f"voices_{param_gender}.txt") as f:
		lines = f.readlines()

	param_timbre = str(lines[int(args.voice)-1].split(",")[1])

	chat = ChatTTS.Chat()
	chat.load(compile=False) # Set to True for better performance

	texts = param_text

	params_infer_code = ChatTTS.Chat.InferCodeParams(
		spk_emb = param_timbre,
		temperature = .3,
		top_P = 0.7,
		top_K = 20,
	)

	params_refine_text = ChatTTS.Chat.RefineTextParams(
		prompt='[oral_2][laugh_0][break_4]',
	)

	wavs = chat.infer(
		texts,
		params_refine_text=params_refine_text,
		params_infer_code=params_infer_code,
	)

	wavs = chat.infer(texts,skip_refine_text=False,params_refine_text=params_refine_text,params_infer_code=params_infer_code)
	torchaudio.save(f"{dir_home}Audio/TTS/chattts_test.wav", torch.from_numpy(wavs[0]), 24000)
