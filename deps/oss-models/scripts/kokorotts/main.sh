#!/bin/bash

# kokoro-tts -v default -f /tmp/text.txt

APP="${HOME}/.local/share/oss-models/kokoro-tts"
source "${APP}/bin/activate"
FILE_TS=$(date +%s)

while getopts ":v:f:" opt; do
  case ${opt} in
    v ) v=$OPTARG;;
    f ) f=$OPTARG;;
    \? ) echo "Usage: kokoro-tts [-v (voice)] [-f (text file)]";;
  esac
done

mkdir -p ${APP}/app/kokoro-tts/static
cd ${APP}/app/kokoro-tts

bash -c "${APP}/app/kokoro-tts/kokoro-tts ${f} ${HOME}/Audio/TTS/Kokoro/output_${FILE_TS}.wav --speed 1.2 --lang en-us --voice ${v}"

deactivate
