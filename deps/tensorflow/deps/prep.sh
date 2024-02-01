#!/bin/bash

mkdir -p content/PetImages
mkdir -p content/Dataset
mkdir -p content/Models

rm -rf content/Dataset/Cat
rm -rf content/Dataset/Dog

rm -rf content/PetImages/Cat
rm -rf content/PetImages/Dog

wget --no-check-certificate -nc \
	"https://download.microsoft.com/download/3/E/1/3E1C3F21-ECDB-4869-8368-6DEBA77B919F/kagglecatsanddogs_5340.zip" \
	-O "cats-and-dogs.zip"

unzip cats-and-dogs.zip

sleep 1

rm ./PetImages/Cat/666.jpg
rm ./PetImages/Dog/11702.jpg

sleep 1

rm *.pdf
rm readme[1].txt
mv PetImages/ content/

#./prep.py
