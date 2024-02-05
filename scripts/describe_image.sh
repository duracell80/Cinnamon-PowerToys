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
	AI_MODEL_SET="yes"
elif [ "$2" = "moondream" ]; then
        AI_MODEL="moondream"
	AI_MODEL_SET="yes"
elif [ "$2" = "ask" ]; then
	AI_MODEL_SET="yes"
	AI_MODEL=$(zenity --list \
	--width=500 \
	--height=300 \
	--title="Choose a conversion profile" \
	--column="Profile" --column="Description" \
		llava "Describe using the LLaVA image model" \
		moondream "Describe using the Moondream image model" )
else
	AI_MODEL_SET="no"
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
		"06" "Can you provide a list of keywords for this image?" \
		"07" "In this image is the scene located indoors or outdoors?" \
		"08" "What kind of movie is the scene pictured in this image from?" \
		"09" "Can you write some short trivia questions based on this image?" \
		"11" "Give me some I Spy recommendations from this image" \
		"12" "Give me some recommendations on improving the composition" \
		"30" "Provide your own prompt ...")

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
                PROMPT="Provide an extensive comma separated list of keywords that describe objects in this image"
	elif [ "$PQ" = "07" ]; then
                PROMPT="In this image, is the scene located indoors or outdoors and describe your reasoning why you came to this conclusion"
	elif [ "$PQ" = "08" ]; then
                PROMPT="What movie or television show do you think the scene in the image is from and what kind of movie or show is it?"
	elif [ "$PQ" = "09" ]; then
                PROMPT="Write a few trivia questions based on details that you see in this image"
	elif [ "$PQ" = "11" ]; then
                PROMPT="The objective of the game Eye Spy is to pick random objects from a scene and note what letter they begin with; can you find 3 objects in the image and say what letter they begin with?"
	elif [ "$PQ" = "12" ]; then
                PROMPT="Provide some recommendations on improving the composition or framing of this photograph and explain the reasoning behind these choices"
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
echo "15"

TS=$(date +%s)
if [ "$AI_MODEL_SET" = "yes" ]; then
	echo "# Passing the image ${FILE_NME}.${FILE_EXT} to ${AI_MODEL}, please be patient ..."

	touch "${1}.txt"

	notify-send --hint=string:image-path:"${1}" --urgency=normal --icon=dialog-information-symbolic "Nemo Action - Describe Image (${AI_MODEL})" "An action is being run on your local machine only to describe the selected image. More than 16GB of total system RAM may be needed to run this local model and some patience. A dialog will appear with the resulting description once completed."

	if [ "$AI_MODEL" = "llava" ]; then
		${HOME}/.local/share/powertoys/describe_llava.py -i "${1}" -p "${PROMPT}"
	elif [ "$AI_MODEL" = "moondream" ]; then
		${HOME}/.local/bin/moondream "${1}" "${PROMPT}"
	fi

	c=15
	while [[ $(cat "${1}.txt" | wc -c) == "0" ]]
	do
        	c=$(( $c + 1 ))
        	echo "${c}"
        	sleep 2
	done

	RESPONSE=$(cat "${1}.txt")

	IMG_KEYS=$(exiftool -keywords "${1}" | cut -d ":" -f2)
	IMG_COMB="Keywords:${IMG_KEYS} Description:${RESPONSE}"

	exiftool -overwrite_original -Exif:ImageDescription="${IMG_COMB}" -Exif:XPComment="${IMG_COMB}" -Description="${IMG_COMB}" "${1}"

	mkdir -p "${FILE_DIR}/.comments"
	echo "[Description Generated: ${FILE_TIM} with ${PROMPT} ]\n${RESPONSE}\n\n" >> "${FILE_DIR}/.comments/${FILE_NME}_${FILE_EXT}.txt"

	notify-send --hint=string:image-path:"$1" --urgency=normal --icon=emblem-ok-symbolic "Nemo Action Completed - Describe Image (${AI_MODEL})" "An image description has been appended to a file named ${FILE_NME}_${FILE_EXT}.txt in the .comments folder. Thank you for using Visual Assistant!"

	#echo "${RESPONSE}" | xclip -sel clip

fi

echo "95" ; sleep 1
echo "# Completed ${FILE_NME}.${FILE_EXTDEST}"
echo "100" ; sleep 1
) |
zenity --progress --title="Describing image" --text="Running image description model" --percentage=25 --width=500 --timeout=400
#zenity --info --text="$(cat $1.txt)"

zenity --text-info --title="Description of image" --filename="${1}.txt"

if [ "$?" = -1 ] ; then
        zenity --error \
          --text="Conversion canceled"
fi

rm -f "${1}.txt"
