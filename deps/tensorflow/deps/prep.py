#!/home/lee/git/examples/modelmaker/bin/python3.9

# https://learnopencv.com/tensorflow-lite-model-maker-create-models-for-on-device-machine-learning/

#Importing zipfile
#import zipfile
#Downloading the Cats and Dogs Dataset from Microsoft Download
# wget --no-check-certificate https://download.microsoft.com/download/3/E/1/3E1C3F21-ECDB-4869-8368-6DEBA77B919F/kagglecatsanddogs_5340.zip -O cats-and-dogs.zip

#Saving zip file
#local_zip = 'cats-and-dogs.zip'
#zip_ref   = zipfile.ZipFile(local_zip, 'r')

#Extracting zip file
#zip_ref.extractall('/content/')
#zip_ref.close()


#Importing libraries
from PIL import Image
import glob
import os
from pathlib import Path

#Converting images in cat folder to png format
current_dir = Path('./content/PetImages/Cat').resolve()
outputdir = Path('./content/Dataset').resolve()
out_dir = outputdir / "Cat"
os.mkdir(out_dir)
cnt = 0

for img in glob.glob(str(current_dir / "*.jpg")):
	filename = Path(img).stem
	Image.open(img).save(str(out_dir / f'{filename}.png'))
	cnt = cnt + 1
	print(cnt)

#Converting images in dog folder to png format
current_dir = Path('./content/PetImages/Dog/').resolve()
outputdir = Path('./content/Dataset/').resolve()
out_dir = outputdir / "Dog"
os.mkdir(out_dir)
cnt = 0

for img in glob.glob(str(current_dir / "*.jpg")):
	filename = Path(img).stem
	Image.open(img).convert('RGB').save(str(out_dir / f'{filename}.png'))
	cnt = cnt + 1
	print(cnt)


