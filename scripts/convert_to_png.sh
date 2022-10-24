#!/bin/sh

FILE_DIR=$(dirname "$2")
FILE_BIT=$(basename "$2")

FILE_NME=${FILE_BIT%%.*}
FILE_EXT=${FILE_BIT##*.}


if [ "$1" = "png-ask" ]; then
    TYPE=$(zenity --list \
      --width=500 \
      --height=300 \
      --title="Choose a conversion profile" \
      --column="Profile" --column="Description" \
        png-icon "Convert using the icon profile")
        
    FILE_EXTDEST="png"
        
elif [ "$1" = "png" ]; then
    TYPE="png"
    FILE_EXTDEST="png"
    
else
    zenity --error --text="No transcoding profile was given"
    exit
fi

(
echo "50"
echo "# Converting Image to ${FILE_NME}.${FILE_EXTDEST}"

if [ "$TYPE" = "png" ]; then
    convert "$2" "${FILE_DIR}/${FILE_NME}.${FILE_EXTDEST}"
else
    convert "$2" "${FILE_DIR}/${FILE_NME}.${FILE_EXTDEST}"
fi

echo "75" ; sleep 1
echo "# Completed ${FILE_NME}.${FILE_EXTDEST}"
echo "100" ; sleep 1
) |
zenity --progress \
  --title="Converting to PNG" \
  --text="Running convert ..." \
  --percentage=25 \
  --width=500 \
  --timeout=15

if [ "$?" = -1 ] ; then
        zenity --error \
          --text="Conversion canceled"
fi