#!/bin/bash

if ! [ -x "$(which wget)" ]; then
	sudo apt install wget
fi

if ! [ -x "$(which mp3tag)" ]; then
	sudo apt install mp3blaster
fi

mkdir -p $HOME/Music/Podcasts/EarthFM
wget -nc -q https://earth.fm/podcast --output-document="/tmp/earthfm.html"

RAW=$(cat /tmp/earthfm.html | grep -io 'href="/podcast/.\{0,200\}' | cut -d "/" -f3 | uniq | tr '\n' ';')
IFS='; ' read -r -a array <<< "$RAW"

for element in "${array[@]: 1:10}"
do
        wget -nc -q https://earth.fm/podcast/$element --output-document="/tmp/$element"
        FILE=$(cat /tmp/$element | grep -io 'download file.\{0,200\}' | head -n1 | cut -d '"' -f2)
        wget -nc $FILE --output-document="$HOME/Music/Podcasts/EarthFM/$element.mp3"

	TRACK=$(echo $element | sed 's/-/ /g' | sed 's/\b\(.\)/\u\1/g')
	mp3tag -a "Various Artists" -l "Earth FM" -s "$TRACK" -g 026 "$HOME/Music/Podcasts/EarthFM/$element.mp3"
	rm /tmp/$element
done
