#!/usr/bin/python3
# https://developers.google.com/mediapipe/solutions/vision/object_detector/python#image

# python3 -m pip install mediapipe numpy cv

import os, argparse
import numpy as np
import mediapipe as mp
from mediapipe.tasks import python
from mediapipe.tasks.python import vision

import urllib.request

global model_file, model_conf

model_conf	= 45
model_path	= f"{os.path.expanduser('~/')}.local/share/tensorflow"
model_file 	= f"efficientdet_lite2.tflite"
model_dest      = f"{model_path}/{model_file}"


model_url 	= "https://storage.googleapis.com/mediapipe-models/object_detector/efficientdet_lite2/float16/latest/{model_file}"

if not os.path.isfile(model_dest):
	print("[i] Downloading model")
	os.system(f"mkdir -p {model_path}")
	urllib.request.urlretrieve(model_url, model_dest)


def unique(list1):
	x = np.array(list1)
	return(np.unique(x))


def analyze_image(image_file, image_mode = "object"):

	BaseOptions 		= mp.tasks.BaseOptions
	ObjectDetector 		= mp.tasks.vision.ObjectDetector
	ObjectDetectorOptions 	= mp.tasks.vision.ObjectDetectorOptions
	VisionRunningMode 	= mp.tasks.vision.RunningMode

	options = ObjectDetectorOptions( base_options=BaseOptions(model_asset_path = model_dest), max_results=20, running_mode=VisionRunningMode.IMAGE)

	with ObjectDetector.create_from_options(options) as detector:
		detection_result = detector.detect(mp.Image.create_from_file(f"{image_file}"))


	keywords = []
	for index in detection_result.detections:
		for item in index.categories:
			if item.score > (model_conf / 100):
				keywords.append(item.category_name)

	keychain = ""
	keywords = unique(keywords)
	for keyword in keywords:
		keychain+= f"{keyword}, "

	keychain = keychain[:-2]
	os.system(f"exiftool -overwrite_original -keywords^='{keychain}' {image_file}")

	return keychain


def parse_arguments():
	parser = argparse.ArgumentParser(description='MediaPipe Image Analysis')
	parser.add_argument('-i', '--image', required=True, help='Path to the image file')
	parser.add_argument('-m', '--mode', default='objects', help='The type of model to run')

	return parser.parse_args()

if __name__ == "__main__":
	args = parse_arguments()

	result = analyze_image(args.image, args.mode)
	print(result)
