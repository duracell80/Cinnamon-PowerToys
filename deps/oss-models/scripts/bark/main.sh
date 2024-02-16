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
		IN_FILE="/tmp/bark_test.txt"
        else
		IN_FILE="${2}"
	fi


fi


APP="${HOME}/.local/share/oss-models/bark"
source "${APP}/bin/activate"
START=$(date +%s)

bash -c "${APP}/bin/python3 ${APP}/app/main.py --cpu --voice=${IN_VOICE} --file=${IN_FILE}"

END=$(date +%s)
TOTAL=$(( $END - $START ))

echo "Running time: ${TOTAL}s"

if [[ "${IN_FILE}" == "/tmp/bark_test.txt" ]]; then
	play "/tmp/bark_test.wav" &
fi
