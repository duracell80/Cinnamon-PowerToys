#!/bin/sh

FILE_DIR=$(dirname "$2")
FILE_BIT=$(basename "$2")

FILE_NME=${FILE_BIT%%.*}
FILE_EXT=${FILE_BIT##*.}




(
echo "50"
echo "# Extracting audio from ${FILE_NME}.${FILE_EXT} to ${FILE_NME}.${1}"

if [ "$1" = "flac" ]; then
    ffmpeg -i "$2" -y -vn -af aformat=s32:176000 "${FILE_DIR}/${FILE_NME}.flac"
elif [ "$1" = "mp3" ]; then
    ffmpeg -i "$2" -y -vn -b:a 192K "${FILE_DIR}/${FILE_NME}.mp3"
fi

echo "75" ; sleep 1
echo "# Completed ${FILE_NME}.$1"
echo "100" ; sleep 1
) |
zenity --progress \
  --title="Converting to ${1}" \
  --text="Running ffmpeg ..." \
  --percentage=25 \
  --width=500 \
  --timeout=15

if [ "$?" = -1 ] ; then
        zenity --error \
          --text="Conversion canceled"
fi