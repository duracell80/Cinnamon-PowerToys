#!/bin/sh
# https://developers.google.com/mediapipe/solutions/vision/image_classifier

if ! [ "which zenity" ]; then
	echo 'Error: Zenity is not installed.' >&2
	notify-send --urgency=normal --icon=dialog-error-symbolic "Zenity is not installed"
	sudo apt install zenity
	exit 1
fi

AI_MODEL="classify"
IMG_LOOPS=$#

(
echo "0"

if [ "$AI_MODEL" = "classify" ]; then
	i=0
	for IMG_FILE in "$@"
	do
		i=$(( $i + 1 ))
		echo "# Passing the image ${i} of ${IMG_LOOPS} to MediaPipe to classify ..."
		${HOME}/.local/share/powertoys/classify_images.py -i "${IMG_FILE}"
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
	done
fi

echo "# Completed classification of all selected image files"
sleep 2
echo "100"; sleep 1
) |
zenity --progress --title="Classify image" --text="Running image classification model" --percentage=0 --width=500

#rm -f "${1}_keys.txt"

if [ "$?" = -1 ] ; then
        zenity --error \
          --text="Conversion canceled"
fi
