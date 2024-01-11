#!/bin/sh
# https://www.louisbouchard.ai/llava

if ! [ "which zenity" ]; then
	echo 'Error: Zenity is not installed.' >&2
	notify-send --urgency=normal --icon=dialog-error-symbolic "Zenity is not installed"
	sudo apt install zenity
	exit 1
fi

if ! [ "which ollama" ]; then
	echo 'Error: Ollama is not installed.' >&2
	notify-send --urgency=normal --icon=dialog-error-symbolic "Ollama is not installed"
	exit 1
fi


FILE_DIR=$(dirname "$1")
FILE_BIT=$(basename "$1")

FILE_NME=${FILE_BIT%%.*}
FILE_EXT=${FILE_BIT##*.}
FILE_TIM=$(date -d "today" +"%Y%m%d%H%M%S")


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

if [ "$3" = "ask" ]; then
	PQ=$(zenity --list \
        --width=500 \
        --height=300 \
        --title="Choose a prompt to ask of this image" \
        --column="Choice" --column="Question" \
                "01" "Can you summerize this image?" \
		"02" "What is unusual about this image?" \
		"03" "What is normal about this image?" \
		"04" "Can you tell me about the location of this image?" \
		"05" "Can you tell me about the objects in the image??" \
		"20" "Ask my own question ...")

	if [ "$PQ" = "01" ]; then
		PROMPT="Describe this image in detail"
	elif [ "$PQ" = "02" ]; then
		PROMPT="What is unusual about this image?"
	elif [ "$PQ" = "03" ]; then
                PROMPT="What is normal about this image?"
	elif [ "$PQ" = "04" ]; then
                PROMPT="Tell me about the location featured in this image"
	elif [ "$PQ" = "05" ]; then
                PROMPT="Tell me about the objects in this image, how many there are and anything else to note about the objects "
	else
		UQ=$(zenity --entry --width=500 --height=100 --title="What would you like to ask of this image?")
		PROMPT="In this image; ${UQ}"

		if [ "$PROMPT" = "In this image; " ]; then
			zenity --error --text="No question asked, exiting."
			exit
		fi
	fi
else
	PROMPT="describe this image in detail"
fi
PROMPT="${PROMPT} ${1}"


(
echo "50"

if [ "$AI_MODEL" = "llava" ]; then
	echo "# Passing the image ${FILE_NME}.${FILE_EXT} to LLaVA, please be patient ..."

	notify-send --hint=string:image-path:"$1" --urgency=normal --icon=dialog-information-symbolic "Nemo Action - Describe Image (LLaVA)" "An action is being run on your local machine only to describe the selected image. More than 8GB of total system RAM may be needed to run this local model in Ollama and some patience. A dialog will appear with the resulting description once completed."
	RESPONSE=$("${HOME}/.local/share/powertoys/describe_llava.py" -i "$1" -p "${PROMPT}")
	RESPTEXT=$(cat "${HOME}/ollama_llava_response.txt")
	notify-send --urgency=normal --icon=emblem-ok-symbolic "Nemo Action Completed - Describe Image (LLaVA)" "An image description has been copied to your clipboard. Thank you for using LLaVA Visual Assistant!"

	echo "${RESPTEXT}" | xclip -sel clip
fi

echo "75" ; sleep 1
echo "# Completed ${FILE_NME}.${FILE_EXTDEST}"
echo "100" ; sleep 1
) |
zenity --progress --title="Describing image" --text="Running image description model" --percentage=25 --width=500 --timeout=600

zenity --text-info --title="Description of image" --filename="/tmp/ollama_llava_response.txt"

if [ "$?" = -1 ] ; then
        zenity --error \
          --text="Conversion canceled"
fi
