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
        --height=400 \
        --title="Choose a prompt to ask of this image" \
        --column="Choice" --column="Question" \
                "01" "Can you summerize this image?" \
		"02" "What is unusual about this image?" \
		"03" "What is normal about this image?" \
		"04" "Can you tell me about the location of this image?" \
		"05" "Can you tell me about the objects in this image?" \
		"06" "Can you count the objects in this image?" \
		"07" "In this image is the scene located indoors or outdoors?" \
		"08" "What kind of movie is the scene pictured in this image from?" \
		"09" "Can you write some short trivia questions based on this image?" \
		"10" "Give me some I Spy recommendations from this image" \
		"30" "Ask my own prompt ...")

	if [ "$PQ" = "01" ]; then
		PROMPT="Describe this image in detail"
	elif [ "$PQ" = "02" ]; then
		PROMPT="What is unusual about this image?"
	elif [ "$PQ" = "03" ]; then
                PROMPT="What is normal about this image?"
	elif [ "$PQ" = "04" ]; then
                PROMPT="Tell me about the location featured in this image"
	elif [ "$PQ" = "05" ]; then
                PROMPT="Tell me about the objects in this image, how many there are and anything else to note about the objects"
	elif [ "$PQ" = "06" ]; then
                PROMPT="Count the number of objects in this image and give a brief description of each"
	elif [ "$PQ" = "07" ]; then
                PROMPT="In this image, is the scene located indoors or outdoors and describe your reasoning why you came to this conclusion"
	elif [ "$PQ" = "08" ]; then
                PROMPT="What movie do you think the scene in the image is from and what kind of movie is it?"
	elif [ "$PQ" = "09" ]; then
                PROMPT="Write a few trivia questions based on details that you see in this image"
	elif [ "$PQ" = "10" ]; then
                PROMPT="The objective of the game Eye Spy is to pick random objects from a scene and note what letter they begin with; can you find 3 objects in the image and say what letter they begin with?"
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
	RESPTEXT=$(cat "${HOME}/ollama_response.txt")

	echo "[Description Generated: ${FILE_TIM} with ${PROMPT} ]\n${RESPTEXT}\n\n" >> "${FILE_DIR}/${FILE_NME}_${FILE_EXT}.txt"

	notify-send --urgency=normal --icon=emblem-ok-symbolic "Nemo Action Completed - Describe Image (LLaVA)" "An image description has been copied to your clipboard and appended to a file named ${FILE_NME}_${FILE_EXT}.txt. Thank you for using LLaVA Visual Assistant!"

	echo "${RESPTEXT}" | xclip -sel clip
fi

echo "75" ; sleep 1
echo "# Completed ${FILE_NME}.${FILE_EXTDEST}"
echo "100" ; sleep 1
) |
zenity --progress --title="Describing image" --text="Running image description model" --percentage=25 --width=500 --timeout=600

zenity --text-info --title="Description of image" --filename="${HOME}/ollama_response.txt"

if [ "$?" = -1 ] ; then
        zenity --error \
          --text="Conversion canceled"
fi