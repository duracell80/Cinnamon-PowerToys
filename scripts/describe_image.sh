#!/bin/sh

FILE_DIR=$(dirname "$1")
FILE_BIT=$(basename "$1")

FILE_NME=${FILE_BIT%%.*}
FILE_EXT=${FILE_BIT##*.}
FILE_TIM=$(date -d "today" +"%Y%m%d%H%M%S")

PROMPT="describe this image in detail ${1}"


if [ "$2" = "llava" ]; then
	AI_MODEL="llava"
else
	AI_MODEL=$(zenity --list \
	--width=500 \
	--height=300 \
	--title="Choose a conversion profile" \
	--column="Profile" --column="Description" \
		llava "Describe using the LLaVA image model")
fi


(
echo "50"
echo "# Passing the image ${FILE_NME}.${FILE_EXT} to the description script, please be patient ..."

if [ "$AI_MODEL" = "llava" ]; then
	RESPONSE=$(./describe_llava.py -i "$1" -p "${PROMPT}")
fi

echo "75" ; sleep 1
echo "# Completed ${FILE_NME}.${FILE_EXTDEST}"
echo "100" ; sleep 1
) |
zenity --progress --title="Describing image" --text="Running image description model" --percentage=25 --width=500

zenity --text-info --title="Description of image" --filename="/tmp/ollama_llava_response.txt"

if [ "$?" = -1 ] ; then
        zenity --error \
          --text="Conversion canceled"
fi
