#!/bin/bash

# sudo apt install imagemagick wget uuid-runtime

DIR_PWD=$(pwd)
DIR_WALL="${HOME}/Pictures/Wallpapers/WLE"
DIR_TEMP="/tmp/wikiwall"

mkdir -p $DIR_TEMP
mkdir -p $DIR_WALL

if [[ $1 == "2020" ]]; then
        wget -q -O $DIR_TEMP/temp.html "https://medium.com/freely-sharing-the-sum-of-all-knowledge/the-majesty-of-nature-and-an-abundance-of-birds-on-full-display-in-wiki-loves-earth-2020-ee956cf74f2d"
elif [[ $1 == "2021" ]]; then
	wget -q -O $DIR_TEMP/temp.html "https://medium.com/freely-sharing-the-sum-of-all-knowledge/its-all-about-the-beauty-in-the-details-with-the-wiki-loves-earth-2021-photo-contest-839e57db72c3"
else
	wget -q -O $DIR_TEMP/temp.html "https://medium.com/freely-sharing-the-sum-of-all-knowledge/experience-some-of-the-worlds-most-beautiful-places-with-wiki-loves-earth-2022-9e22fa72a3c0"
fi
sleep 3

IFS=$'\r\n' GLOBIGNORE='*' command eval  'URL=($(cat $DIR_TEMP/temp.html | grep -Eo "(http|https)://[a-zA-Z0-9./?=_%:-]*" | sort -u | grep -i "wiki/file:"))'
for URL in "${URL[@]}"
do
 	eval 'TYPE=($(echo "${URL}" | cut -d "/" -f5 | cut -d ":" -f2))'
	eval 'FILE=($(echo "${URL}" | cut -d "/" -f5 | cut -d ":" -f2 | cut -d "." -f1))'

	HTML=$(echo "${DIR_TEMP}/temp.html")
	JPEG=$(echo "${DIR_TEMP}/${FILE}.jpg")
	IPNG=$(echo "${DIR_TEMP}/${FILE}.png")
	UUID=$(uuidgen)

	wget -q --read-timeout=30 --tries=3 --random-wait -O $HTML $URL
	sleep 1

	echo "[i] : Downloading image ... ${FILE}"
	if [[ $TYPE == *".png"* ]]; then
  		WALL=$(cat $HTML | grep -Eo "(http|https)://[a-zA-Z0-9./?=_%:-]*" | sort -u | grep -i "1024px-" | grep -i ".png" | head -n4 | tail -n1 | sed "s-thumb/--" | sed 's![^/]*$!!' | sed "s-.png/-.png-")
                wget -q --tries=5 -nc -O $IPNG $WALL
		convert "$IPNG" -geometry 2560x1440^ -gravity center -crop 2560x1440+0+0 "${DIR_WALL}/${UUID}.jpg"
	else
		WALL=$(cat $HTML | grep -Eo "(http|https)://[a-zA-Z0-9./?=_%:-]*" | sort -u | grep -i "px-" | grep -i ".jpg" | head -n4 | tail -n1 | sed "s-thumb/--" | sed 's![^/]*$!!' | sed "s-.jpg/-.jpg-")
		wget -q --tries=5 -nc -O $JPEG $WALL
		convert "$JPEG" -geometry 2560x1440^ -gravity center -crop 2560x1440+0+0 "${DIR_WALL}/${UUID}.jpg"
	fi
	sleep 2
done

rm -f $DIR_TEMP/temp.html

rm -rf $DIR_TEMP/*.jpg
rm -rf $DIR_TEMP/*.png
