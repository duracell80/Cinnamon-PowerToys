#!/bin/sh
# bark from source

if ! [ "which zenity" ]; then
        echo 'Error: Zenity is not installed.' >&2
        notify-send --urgency=normal --icon=dialog-error-symbolic "Zenity is not installed"
        sudo apt install zenity
        exit 1
fi

AI_MODEL="${1}"
MED_LOOPS=$(($# - 1))

if [ "$1" = "ask" ]; then
        AI_MODEL=$(zenity --list \
        --width=500 \
        --height=300 \
        --title="Choose a voice model" \
        --column="Profile" --column="Description" \
                en_speaker_0 "English (M) 0" \
		en_speaker_1 "English (M) 1" \
		en_speaker_2 "English (M) 2" \
		en_speaker_3 "English (M) 3" \
                en_speaker_4 "English (M) 4" \
                en_speaker_5 "English (M) 5" \
		en_speaker_6 "English (M) 6" \
                en_speaker_7 "English (M) 7" \
                en_speaker_8 "English (M) 8" \
		en_speaker_9 "English (F) 9" \
                es_speaker_0 "Spanish (M) 0" \
                es_speaker_1 "Spanish (M) 1" \
                es_speaker_2 "Spanish (M) 2" \
                es_speaker_3 "Spanish (M) 3" \
                es_speaker_4 "Spanish (M) 4" \
                es_speaker_5 "Spanish (M) 5" \
                es_speaker_6 "Spanish (M) 6" \
                es_speaker_7 "Spanish (M) 7" \
                es_speaker_8 "Spanish (F) 8" \
                es_speaker_9 "Spanish (F) 9" \
		fr_speaker_0 "French (M) 0" \
                fr_speaker_1 "French (F) 1" \
                fr_speaker_2 "French (F) 2" \
                fr_speaker_3 "French (M) 3" \
                fr_speaker_4 "French (M) 4" \
                fr_speaker_5 "French (F) 5" \
                fr_speaker_6 "French (M) 6" \
                fr_speaker_7 "French (M) 7" \
                fr_speaker_8 "French (M) 8" \
                fr_speaker_9 "French (M) 9" \
		de_speaker_0 "German (M) 0" \
                de_speaker_1 "German (M) 1" \
                de_speaker_2 "German (M) 2" \
                de_speaker_3 "German (F) 3" \
                de_speaker_4 "German (M) 4" \
                de_speaker_5 "German (M) 5" \
                de_speaker_6 "German (M) 6" \
                de_speaker_7 "German (M) 7" \
                de_speaker_8 "German (F) 8" \
                de_speaker_9 "German (M) 9"  )
else
        AI_MODEL="en_speaker_6"
fi


(
echo "0"

i=0

shift
for MED_FILE in "$@"
do
        i=$(( $i + 1 ))
        echo "# Passing text file ${i} of ${MED_LOOPS} to bark (${AI_MODEL}) and ffmpeg ..."
	echo "25"
	${HOME}/.local/share/oss-models/bark/app/main.sh "${AI_MODEL}" "${MED_FILE}"

	echo "# Text file ${i} of ${MED_LOOPS} transformed to speech!"

	c=75
	while [ $c -le 95 ]
        do
                echo "${c}"
                c=$(( $c + 1 ))
                sleep 0.01
        done
done

echo "# Completed transforming all selected text files"
sleep 1
echo "100"; sleep 1
) |
zenity --progress --title="Text to Speech (BARK)" --text="Running TTS model" --percentage=0 --width=500

if [ "$?" = -1 ] ; then
        zenity --error \
          --text="Transformation canceled"
fi
