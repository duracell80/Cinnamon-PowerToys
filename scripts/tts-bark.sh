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

(
echo "0"

i=0

shift
for MED_FILE in "$@"
do
        i=$(( $i + 1 ))
        echo "# Passing text file ${i} of ${MED_LOOPS} to bark and ffmpeg ..."
	echo "25"
	${HOME}/.local/share/oss-models/bark/app/main.sh en_speaker_6 "${MED_FILE}"

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
