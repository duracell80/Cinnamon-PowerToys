#!/bin/bash

FILE_FUL=$(basename "${1}")
FILE_DIR=$(dirname "${1}")

FILE_NME="${FILE_DIR}/${FILE_FUL%.*}"


./main.py --cpu --model=small.en --audio="${1}"
ffmpeg -y -i "${1}" -i "${FILE_NME}.srt" -i "${FILE_NME}.jpg" -c:v libx264 -pix_fmt yuv420p -vf scale=1280:720 -c:s mov_text -c:a copy "${FILE_NME}.mp4"

