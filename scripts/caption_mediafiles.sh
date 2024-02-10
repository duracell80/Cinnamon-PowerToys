#!/bin/sh
# fater whisper

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
        echo "# Passing media file ${i} of ${MED_LOOPS} to whisper and ffmpeg ..."

	${HOME}/.local/share/oss-models/whisper/app/main.sh "${MED_FILE}"

	echo "# Media file ${i} of ${MED_LOOPS} captioned!"

	c=75
	while [ $c -le 95 ]
        do
                echo "${c}"
                c=$(( $c + 1 ))
                sleep 0.01
        done
done

echo "# Completed captioning of all selected media files"
sleep 1
echo "100"; sleep 1
) |
zenity --progress --title="Caption media" --text="Running media captioning model" --percentage=0 --width=500

if [ "$?" = -1 ] ; then
        zenity --error \
          --text="Captioning canceled"
fi
