#!/bin/sh

FILE_DIR=$(dirname "$2")
FILE_BIT=$(basename "$2")

FILE_NME=${FILE_BIT%%.*}
FILE_EXT=${FILE_BIT##*.}

# https://filesamples.com/formats/heif
# https://filesamples.com/samples/image/heif/sample1.heif
#sudo apt install libheif-examples


(
echo "50"
echo "# Converting HEIF Image to ${FILE_NME}.${1}"
sleep 2
echo "65"
if [ "$1" = "jpg" ]; then
    heif-convert "$2" "${FILE_DIR}/${FILE_NME}.jpg"
    echo "75"
    sleep 2
    echo "# Completed ${FILE_NME}.$1"
    echo "100"

elif [ "$1" = "png" ]; then
    heif-convert "$2" "${FILE_DIR}/${FILE_NME}.png"
    echo "95"
    sleep 2
    echo "# Completed ${FILE_NME}.$1"
    echo "100"
fi

) |
zenity --progress \
  --title="Converting to ${1}" \
  --text="Running convert ..." \
  --percentage=25 \
  --width=500 \
  --timeout=60

if [ "$?" = -1 ] ; then
        zenity --error \
          --text="Conversion canceled"
fi