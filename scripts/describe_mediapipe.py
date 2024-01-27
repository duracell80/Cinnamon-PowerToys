#!/usr/bin/python3
# https://developers.google.com/mediapipe/solutions/vision/object_detector/python#image

import os
import numpy as np
import mediapipe as mp
from mediapipe.tasks import python
from mediapipe.tasks.python import vision


image_file = "/home/lee/Pictures/test2.jpg"

def unique(list1):
	x = np.array(list1)
	return(np.unique(x))


BaseOptions 		= mp.tasks.BaseOptions
ObjectDetector 		= mp.tasks.vision.ObjectDetector
ObjectDetectorOptions 	= mp.tasks.vision.ObjectDetectorOptions
VisionRunningMode 	= mp.tasks.vision.RunningMode

options = ObjectDetectorOptions( base_options=BaseOptions(model_asset_path="/home/lee/.local/share/efficientdet_lite2.tflite"), max_results=20, running_mode=VisionRunningMode.IMAGE)

with ObjectDetector.create_from_options(options) as detector:
    detection_result = detector.detect(mp.Image.create_from_file(f"{image_file}"))


keywords = []
for index in detection_result.detections:
	for item in index.categories:
		if item.score > (50 / 100):
			keywords.append(item.category_name)

keychain = ""
keywords = unique(keywords)
for keyword in keywords:
	keychain+= f"{keyword}, "

keychain = keychain[:-2]
print(keychain)
os.system(f"exiftool -overwrite_original -keywords^='{keychain}' {image_file}")
