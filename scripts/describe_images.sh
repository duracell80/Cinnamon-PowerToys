#!/bin/sh
# https://developers.google.com/mediapipe/solutions/vision/image_classifier

if ! [ "which zenity" ]; then
        echo 'Error: Zenity is not installed.' >&2
        notify-send --urgency=normal --icon=dialog-error-symbolic "Zenity is not installed"
        sudo apt install zenity
        exit 1
fi

AI_MODEL="${1}"
IMG_LOOPS=$(($# - 1))

(
echo "0"

i=0

shift
for IMG_FILE in "$@"
do
        i=$(( $i + 1 ))
        echo "# Passing image ${i} of ${IMG_LOOPS} to ${AI_MODEL} to classify ..."

	if [ "$AI_MODEL" = "moondream" ]; then
                ${HOME}/.local/bin/moondream "${IMG_FILE}" "describe this image"
        else
                exit
        fi

        RESPONSE=$(cat "${IMG_FILE}.txt")

	echo "# Image ${i} of ${IMG_LOOPS} completed!"
        if [ $i -lt 95 ]; then
	        c=$i
        else
        	c=0
        fi


	while [ $c -le 95 ]
        do
                echo "${c}"
                c=$(( $c + 1 ))
                sleep 0.02
        done

	rm -f "${IMG_FILE}.txt"
done

echo "# Completed description of all selected image files"
sleep 2
echo "100"; sleep 1
) |
zenity --progress --title="Describe images" --text="Running image description model" --percentage=0 --width=500


if [ "$?" = -1 ] ; then
        zenity --error \
          --text="Conversion canceled"
fi
