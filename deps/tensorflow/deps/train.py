#!/home/lee/git/examples/modelmaker/bin/python3.9

# https://learnopencv.com/tensorflow-lite-model-maker-create-models-for-on-device-machine-learning/

#Importing libraries
#import tensorflow as tf
#from tflite_model_maker import image_classifier
#from tflite_model_maker.image_classifier import DataLoader

#from matplotlib import pyplot as plt

import os

import numpy as np

import tensorflow as tf
assert tf.__version__.startswith('2')

from tflite_model_maker import model_spec
from tflite_model_maker import image_classifier
from tflite_model_maker.config import ExportFormat
from tflite_model_maker.config import QuantizationConfig
from tflite_model_maker.image_classifier import DataLoader

import matplotlib.pyplot as plt


#Loading dataset using the Dataloader
data = DataLoader.from_folder('./content/Dataset')

#Splitting dataset into training, validation and testing data
train_data, rest_data = data.split(0.7)
validation_data, test_data = rest_data.split(0.67)

#Training the model
model = image_classifier.create(train_data, model_spec=model_spec.get('efficientnet_lite0'), validation_data=validation_data, train_whole_model=True,)

loss, accuracy = model.evaluate(test_data)

#Defining Config
config = QuantizationConfig.for_float16()

#Exporting Model
model.export(export_dir='./content/Models/', tflite_filename='model_fp16.tflite', quantization_config=config)

#Evaluating Exported Model
model.evaluate_tflite('./content/Models/model_fp16.tflite', test_data)
