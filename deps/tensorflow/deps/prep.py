#!/home/lee/git/examples/modelmaker/bin/python3.9
# https://learnopencv.com/tensorflow-lite-model-maker-create-models-for-on-device-machine-learning/

#Importing libraries
from PIL import Image
import glob
import os
import sys
from pathlib import Path

import logging
import threading
import time


def thread_function(name, category):
	print(f"[i] Processing {category}")
	time.sleep(2)

	current_dir = Path(f'./content/PetImages/{category}').resolve()
	outputdir = Path(f'./content/Dataset').resolve()
	out_dir = f"{outputdir}/{category}"
	os.mkdir(out_dir)
	cnt = 0

	for img in glob.glob(str(f"{current_dir}/*.jpg")):
		filename = Path(img).stem
		try:
			Image.open(img).save(str(f"{out_dir}/{filename}.png"))
		except:
			print(f"[ERROR - {cnt}] - {category}-{filename}")
		cnt = cnt + 1
		print(f"[{cnt}] - {category}-{filename}")

if __name__ == "__main__":
	format = "%(asctime)s: %(message)s"
	logging.basicConfig(format=format, level=logging.INFO,
                        datefmt="%H:%M:%S")

	threads = list()
	for index in range(2):
		if index == 0:
			category = "Cat"
		elif index == 1:
			category = "Dog"
		else:
			category = "None"

		x = threading.Thread(target=thread_function, args=(index, category))
		threads.append(x)
		x.start()

	for index, thread in enumerate(threads):
		thread.join()

