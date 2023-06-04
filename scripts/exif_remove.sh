#!/bin/sh

if ! [ -x "$(command -v exiftool)" ]; then
  echo 'Error: exiftool is not installed.' >&2
  zenity --error \
          --text="Error: exiftool is not installed."
  exit 1
fi


FILE_DIR=$(dirname "$1")
FILE_BIT=$(basename "$1")

FILE_NME=${FILE_BIT%%.*}
FILE_EXT=${FILE_BIT##*.}


if [ "$FILE_EXT" = "jpeg" ] || [ "$FILE_EXT" = "jpg" ]; then
    
    (
    echo "50"
    exiftool -all= "$1" &
    echo "# Removed exif data from ${FILE_NME}.${FILE_EXT}"
    sleep 2
    echo "75"
    echo "# Original copy sent to trash"
    mv -f ${FILE_DIR}/${FILE_NME}.${FILE_EXT}_original ${HOME}/.local/share/Trash/files
    sleep 1
    echo "100"; sleep 1

    ) |
    zenity --progress \
    --title="Removing exif data" \
    --text="Running exiftool ..." \
    --percentage=25 \
    --width=500 \
    --timeout=5
else
    zenity --error \
          --text="Error: Supplied image is not a .jpg or *.jpeg"
  
fi