#!/usr/bin/python3
# https://developers.google.com/mediapipe/solutions/vision/object_detector/python#image

# python3 -m pip install mediapipe numpy cv

import os, sys, argparse
import numpy as np
import mediapipe as mp
from mediapipe.tasks import python
from mediapipe.tasks.python import vision

import urllib.request

global model_file, model_conf

model_path	= f"{os.path.expanduser('~/')}.local/share/tensorflow"
#model_file 	= f"efficientnet_lite2.tflite"
model_file	= f"classify-petimages_fp16.tflite"
model_dest      = f"{model_path}/{model_file}"


model_url 	= f"https://storage.googleapis.com/mediapipe-models/image_classifier/efficientnet_lite2/float32/latest/{model_file}"

if not os.path.isfile(model_dest):
	os.system(f"mkdir -p {model_path}")
	urllib.request.urlretrieve(model_url, model_dest)

if not os.path.isfile(f"{model_path}/image_classifier_labels.txt"):
	urllib.request.urlretrieve("https://storage.googleapis.com/mediapipe-tasks/image_classifier/labels.txt", f"{model_path}/image_classifier_labels.txt")

def unique(list1):
	x = np.array(list1)
	return(np.unique(x))


def analyze_image(image_file, image_verbosity = "fluid"):

	BaseOptions = mp.tasks.BaseOptions
	ImageClassifier = mp.tasks.vision.ImageClassifier
	ImageClassifierOptions = mp.tasks.vision.ImageClassifierOptions
	VisionRunningMode = mp.tasks.vision.RunningMode

	if image_verbosity == "strict":
		conf_results = 1
		model_conf = 80
	else:
		conf_results = 15
		model_conf = 40


	options = ImageClassifierOptions( base_options=BaseOptions(model_asset_path = model_dest), max_results=conf_results, running_mode=VisionRunningMode.IMAGE)

	with ImageClassifier.create_from_options(options) as classifier:
		classification_result = classifier.classify(mp.Image.create_from_file(f"{image_file}"))

	print(classification_result)

	keywords = []
	for index in classification_result.classifications:
		for item in index.categories:
			if item.score > (model_conf / 10000):
				keywords.append(item.category_name)

	keychain = ""
	keywords = unique(keywords)
	i=0
	for keyword in keywords:
		i+=1
		if i < 5:
			keychain+= f"{keyword}, "

	keychain = keychain[:-2]
	os.system(f"exiftool -overwrite_original -keywords^='{keychain}' {image_file}")

	with open(f'{args.image}_keys.txt', 'w', encoding='utf-8') as f:
		f.write(keychain)

	return keychain


def parse_arguments():
	parser = argparse.ArgumentParser(description='MediaPipe Image Analysis')
	parser.add_argument('-i', '--image', required=True, help='Path to the image file')
	parser.add_argument('-v', '--verbosity', required=False, help='Level of verboseness')

	return parser.parse_args()

if __name__ == "__main__":
	args = parse_arguments()

	result = analyze_image(args.image, args.verbosity)
	print(result)
