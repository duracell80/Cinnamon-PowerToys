#!/bin/bash

if [ $# -eq 0 ]; then
	echo "Usage example: command then ... en_speaker_6 /path/to/text/file.txt"
	exit
else
	if [ -z "$1" ]; then
		IN_VOICE="en_speaker_6"
	else
		IN_VOICE=$1
	fi


	if [ -z "$2" ]; then
		echo "This is a test. In the event of an emergency, please do not panic." > /tmp/bark_test.txt
		IN_TEXT="/tmp/bark_test.txt"
        else
		IN_TEXT="${2}"
	fi


fi

IN_PATH="$(dirname "${IN_TEXT}")"
IN_FILE="$(basename "${IN_TEXT}")"
IN_NAME="${IN_FILE%.*}"

mkdir -p $IN_PATH/.meta


APP="${HOME}/.local/share/oss-models/bark"
source "${APP}/bin/activate"
START=$(date +%s)

bash -c "${APP}/bin/python3 ${APP}/app/main.py --cpu --voice=${IN_VOICE} --file=${IN_TEXT}" 2> /dev/null

END=$(date +%s)
TOTAL=$(( $END - $START ))

echo "Running time: ${TOTAL}s"


if [[ "${IN_FILE}" == "/tmp/bark_test.txt" ]]; then
	play "/tmp/bark_test.wav" &
else
	if ! [ "which ffmpeg" ]; then
        	echo "[i] ffmpeg not installed, files are to be found in the .meta directory"
		exit
	else
	        ffmpeg -n -f concat -safe 0 -i <( for f in $IN_PATH/.meta/$IN_NAME_*.wav; do echo "file '$(IN_PATH/.meta)/$f'"; done ) $IN_PATH/$IN_NAME.wav
		rm -f $IN_PATH/.meta/$IN_NAME_*.wav
	fi
	exit
fi
