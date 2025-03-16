#!/bin/bash

# auralis-tts -v default -f /tmp/text.txt

APP="${HOME}/.local/share/oss-models/auralis-tts"
source "${APP}/bin/activate"
#START=$(date +%s)

while getopts ":v:f:" opt; do
  case ${opt} in
    v ) v=$OPTARG;;
    f ) f=$OPTARG;;
    \? ) echo "Usage: auralis-tts [-v (voice)] [-f (text file)]";;
  esac
done

FILE_TEXT=$(cat $f)

bash -c "${APP}/bin/python3 ${APP}/app/main.py --voice=${v} --text='${FILE_TEXT}'"

echo "[i] TTS Complete, check the ~/Audio directory"
deactivate
