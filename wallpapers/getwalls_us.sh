#!/bin/bash

#sudo apt install imagemagick wget uuid-runtime

DIR_PWD=$(pwd)
DIR_WALL="${HOME}/Pictures/Wallpapers/US/Collections"
DIR_TEMP="/tmp/unsplash"

mkdir -p $DIR_TEMP
mkdir -p $DIR_WALL

if [ ! -z "$1" ]; then
	if [[ $1 == *"unsplash.com/collections"* ]]; then
		CPG="${1}"
	else
		CPG="https://unsplash.com/collections/220381/earth-is-awesome"
	fi
else
	CPG="https://unsplash.com/collections/220388/macos-desktop-wallpapers"
fi
wget -q -nc -O $DIR_TEMP/temp.html "${CPG}"
ITM=( $(cat $DIR_TEMP/temp.html | grep -i 'itemProp="contentUrl"' | grep -Eo "(http|https)://[a-zA-Z0-9./?=_%:-]*" | uniq | grep -i "photo-" | uniq) )



for URL in "${ITM[@]}"
do
 	if [[ $URL == *"ixlib"* ]]; then
		URL=$(echo "${URL}" | cut -d "?" -f1)
		URL_2560="${URL}?w=2560&q=80"
		URL_FILE=$(echo "${URL}" | cut -d "/" -f4)
		URL_TIME=$(echo "${URL_FILE}" | cut -d "-" -f2)
		URL_NAME=$(echo "${CPG}" | cut -d "/" -f6)
		URL_UUID=$(echo "${URL_FILE}" | cut -d "-" -f3)

		UUID="${URL_TIME}-${URL_UUID}"
		HTML=$(echo "${DIR_TEMP}/temp.html")
		JPEG=$(echo "${DIR_TEMP}/${UUID}.jpg")

		mkdir -p "${DIR_WALL}/${URL_NAME,,}"

		echo "[i] : Processing ${URL_FILE,,} from collection ${URL_NAME,,} and cropping to 16:9 format"
		wget -q --tries=5 -nc -O $JPEG $URL_2560
		convert "$JPEG" -geometry 2560x1440^ -gravity center -crop 1920x1080+0+0 "${DIR_WALL}/${URL_NAME}/${UUID}.jpg"
	fi
	# Slow it down
	sleep 15
done

#rm -f $DIR_TEMP/temp.html
#rm -rf $DIR_TEMP/*.jpg

DIR_SET=$(cat ~/.config/cinnamon/backgrounds/user-folders.lst | grep -i "wallpapers/us/collections/${URL_NAME,,}" | wc -l)

if [[ $DIR_SET != "1" ]]; then
	echo "$HOME/Pictures/Wallpapers/US/Collections/${URL_NAME,,}" >> $HOME/.config/cinnamon/backgrounds/user-folders.lst
        notify-send --urgency=normal --category=transfer.complete --icon=cs-backgrounds-symbolic "New backgrounds downloaded!" "Right click the desktop, choose 'Change Desktop Background' to see the us/${URL_NAME,,} folder in the background chooser"
fi

sort $HOME/.config/cinnamon/backgrounds/user-folders.lst | uniq > $HOME/.config/cinnamon/backgrounds/user-folders.lst.tmp && mv -f $HOME/.config/cinnamon/backgrounds/user-folders.lst.tmp $HOME/.config/cinnamon/backgrounds/user-folders.lst
