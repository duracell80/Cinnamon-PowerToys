#!/bin/sh

FILE_DIR=$(dirname "$2")
FILE_BIT=$(basename "$2")

FILE_NME=${FILE_BIT%%.*}
FILE_EXT=${FILE_BIT##*.}


if [ "$1" = "webp-ask" ]; then
    TYPE=$(zenity --list \
      --width=500 \
      --height=300 \
      --title="Choose a transcoding profile" \
      --column="Profile" --column="Description" \
        webp-photo "Convert using the photo profile and doesn't copy metadata" \
        webp-picture "Convert using the picture profile and copies metadata" \
        webp-drawing "Convert using the drawing profile" \
        webp-icon "Convert using the icon profile" \
        webp-text "Convert using the text profile" \
        webp-lossless "Convert using the lossless profile")
        
    FILE_EXTDEST="webp"
        
elif [ "$1" = "webp-lossless" ]; then
    TYPE="webp-lossless"
    FILE_EXTDEST="webp"
    
else
    zenity --error --text="No transcoding profile was given"
    exit
fi

(
echo "50"
echo "# Converting Image to ${FILE_NME}.${FILE_EXTDEST}"

if [ "$TYPE" = "webp-photo" ]; then
    cwebp -preset photo -q 70 -metadata none "$2" -o "${FILE_DIR}/${FILE_NME}.${FILE_EXTDEST}"
elif [ "$TYPE" = "webp-picture" ]; then
    cwebp -preset picture -q 70 "$2" -o "${FILE_DIR}/${FILE_NME}.${FILE_EXTDEST}"
elif [ "$TYPE" = "webp-drawing" ]; then
    cwebp -preset drawing -alpha_q 100 -q 85 "$2" -o "${FILE_DIR}/${FILE_NME}.${FILE_EXTDEST}"
elif [ "$TYPE" = "webp-icon" ]; then
    cwebp -preset icon -alpha_q 100 -q 70 "$2" -o "${FILE_DIR}/${FILE_NME}.${FILE_EXTDEST}"
elif [ "$TYPE" = "webp-text" ]; then
    cwebp -preset text -q 95 "$2" -o "${FILE_DIR}/${FILE_NME}.${FILE_EXTDEST}"
elif [ "$TYPE" = "webp-losless" ]; then
    cwebp -z 9 "$2" -o "${FILE_DIR}/${FILE_NME}.${FILE_EXTDEST}"
else
    cwebp -preset default -q 75 "$2" -o "${FILE_DIR}/${FILE_NME}.${FILE_EXTDEST}"
fi

echo "75" ; sleep 1
echo "# Completed ${FILE_NME}.${FILE_EXTDEST}"
echo "100" ; sleep 1
) |
zenity --progress \
  --title="Converting to WEBP" \
  --text="Running cwebp ..." \
  --percentage=25 \
  --width=500 \
  --timeout=15

if [ "$?" = -1 ] ; then
        zenity --error \
          --text="Conversion canceled"
fi