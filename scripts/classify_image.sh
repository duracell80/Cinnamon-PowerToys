#!/bin/sh
# https://developers.google.com/mediapipe/solutions/vision/image_classifier

if ! [ "which zenity" ]; then
	echo 'Error: Zenity is not installed.' >&2
	notify-send --urgency=normal --icon=dialog-error-symbolic "Zenity is not installed"
	sudo apt install zenity
	exit 1
fi

FILE_DIR=$(dirname "$1")
FILE_BIT=$(basename "$1")

FILE_NME=${FILE_BIT%%.*}
FILE_EXT=${FILE_BIT##*.}

AI_MODEL="classify"

(
echo "15"


TS=$(date +%s)
if [ "$AI_MODEL" = "classify" ]; then
	echo "# Passing the image ${FILE_NME}.${FILE_EXT} to MediaPipe to classify, please be patient ..."

	${HOME}/.local/share/powertoys/classify_image.py -i "${1}" -m "classify"
	c=15
	while [ $c -le 95 ]
    do
        echo "${c}"
        c=$(( $c + 1 ))
        sleep 0.02
    done

    fi

echo "95" ; sleep 1
echo "# Completed classification of ${FILE_NME}.${FILE_EXTDEST}"
echo "100" ; sleep 1
) |
zenity --progress --title="Classify image" --text="Running image classification model" --percentage=15 --width=500 --timeout=5

rm -f "${1}_keys.txt"

if [ "$?" = -1 ] ; then
        zenity --error \
          --text="Conversion canceled"
fi
