#!/home/lee/git/examples/modelmaker/bin/python3.9

# https://learnopencv.com/tensorflow-lite-model-maker-create-models-for-on-device-machine-learning/

#Importing libraries
from tflite_model_maker import image_classifier
from tflite_model_maker.image_classifier import DataLoader

from matplotlib import pyplot as plt

#Loading dataset using the Dataloader
data = DataLoader.from_folder('./content/Dataset')

#Splitting dataset into training, validation and testing data
train_data, rest_data = data.split(0.7)
validation_data, test_data = rest_data.split(0.67)

#Visualizing images in the dataset
plt.figure(figsize=(10,10))
for i, (image, label) in enumerate(data.gen_dataset().unbatch().take(25)):
  plt.subplot(5,5,i+1)
  plt.xticks([])
  plt.yticks([])
  plt.grid(False)
  plt.imshow(image.numpy(), cmap=plt.cm.gray)
  plt.xlabel(data.index_to_label[label.numpy()])
#plt.show()
plt.savefig("dataset.png")
