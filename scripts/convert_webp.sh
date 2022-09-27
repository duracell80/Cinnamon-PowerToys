#!/bin/sh

FILE_DIR=$(dirname "$2")
FILE_BIT=$(basename "$2")

FILE_NME=${FILE_BIT%%.*}
FILE_EXT=${FILE_BIT##*.}


(
echo "50"
echo "# Converting WebP Image to ${FILE_NME}.${1}"

if [ "$1" = "jpg" ]; then
    ffmpeg -i "$2" -y "${FILE_DIR}/${FILE_NME}.jpg"
elif [ "$1" = "png" ]; then
    ffmpeg -i "$2" -y "${FILE_DIR}/${FILE_NME}.png"
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
  --timeout=1

if [ "$?" = -1 ] ; then
        zenity --error \
          --text="Conversion canceled"
fi