#!/bin/bash

#sudo apt install imagemagick wget uuid-runtime

DIR_PWD=$(pwd)
DIR_WALL="/usr/share/backgrounds/powertoys"
DIR_TEMP="/tmp/unsplash"

mkdir -p $DIR_TEMP
mkdir -p $DIR_WALL

if [ ! -z "$1" ]; then
	CPG="nature"
else
	CPG=$1
fi

cd $DIR_TEMP
rm -rf photo-*

wget -q -nc --content-disposition  https://source.unsplash.com/random/1920/?$CPG
echo $(ls photo-* | sed 's/w=1080/w=2560/g')
#URL_2560="${URL}?w=2560&q=80"
