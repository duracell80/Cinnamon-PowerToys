#!/bin/bash

FILE_FUL=$(basename "${1}")
FILE_DIR=$(dirname "${1}")
FILE_EXT="${FILE_FUL##*.}"

FILE_NME="${FILE_FUL%.*}"
mkdir -p "${FILE_DIR}/.meta"

ffmpeg -hide_banner -loglevel error -n -i "${1}" -b:a 192K -vn "${FILE_DIR}/.meta/${FILE_NME}_audio.mp3"

if [ -f "${FILE_DIR}/.meta/${FILE_NME}_audio.mp3" ]; then
	./main.py --cpu --model=small.en --file="${FILE_DIR}/.meta/${FILE_NME}_audio.mp3"
fi


if [[ $FILE_EXT == *"mp3"* ]] || [[ $FILE_EXT == *"wav"* ]]; then
	ffmpeg -hide_banner -loglevel error -y -i "${1}" -i "${FILE_DIR}/.meta/${FILE_NME}_audio.srt" -i "${FILE_DIR}/${FILE_NME}.jpg" -c:v libx264 -pix_fmt yuv420p -vf scale=1280:720 -c:s mov_text -c:a copy "${FILE_DIR}/${FILE_NME}_captioned.mp4"
elif [[ $FILE_EXT == *"mp4"* ]] || [[ $FILE_EXT == *"mkv"* ]]; then
	ffmpeg -hide_banner -loglevel error -y -i "${1}" -i "${FILE_DIR}/.meta/${FILE_NME}_audio.srt" -c:s mov_text -c:v copy -c:a copy "${FILE_DIR}/${FILE_NME}_captioned.mp4"
fi
