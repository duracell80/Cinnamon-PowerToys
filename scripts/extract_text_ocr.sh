#!/bin/sh

TMP=/tmp/ocrscan
touch $TMP && tesseract -l eng --dpi 300 $1 $TMP


TEXT=$(cat "${TMP}.txt")
#espeak -f "${TMP}.txt" -w "${TMP}.wav"
#exiftool -comment="${TEXT}" $1

echo "${TEXT}" | xclip -sel clip

zenity --info --width=400 --height=200 --text "The text extracted has been: \n - Copied to clipboard\n - Saved to ${TMP}.txt"