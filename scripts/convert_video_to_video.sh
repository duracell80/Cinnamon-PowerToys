#!/bin/sh

FILE_DIR=$(dirname "$2")
FILE_BIT=$(basename "$2")

FILE_NME=${FILE_BIT%%.*}
FILE_EXT=${FILE_BIT##*.}

if [ "$1" = "mp4-ask" ]; then
    TYPE=$(zenity --list \
      --width=500 \
      --height=300 \
      --title="Choose a transcoding profile" \
      --column="Profile" --column="Description" \
        mp4-copy "Simply copy to an MP4 container" \
        mp4-1080 "Convert to MP4 in 1080p" \
        mp4-720 "Convert to MP4 in 720p" \
        mp4-480 "Convert to MP4 in 480p" \
        mp4-360 "Convert to MP4 in 360p" \
        mp4-240 "Convert to MP4 in 240p")
        
    FILE_EXTDEST="mp4"

elif [ "$1" = "mp5" ]; then
    TYPE="mp5"
    FILE_EXTDEST="mp4"
    
elif [ "$1" = "mp2-ask" ]; then
    TYPE=$(zenity --list \
      --width=500 \
      --height=300 \
      --title="Choose a transcoding profile" \
      --column="Profile" --column="Description" \
        mp2 "Convert to MPEG2 for PAL-DVD")
        
    FILE_EXTDEST="mpeg"
    
elif [ "$1" = "webm" ]; then
    TYPE="webm"
    FILE_EXTDEST="webm"
    
elif [ "$1" = "webm-mp4" ]; then
    TYPE="webm-mp4"
    FILE_EXTDEST="mp4"
    
else
    zenity --error --text="No transcoding profile was given"
    exit
fi

(
echo "50"
echo "# Extracting video with profile $TYPE to ${FILE_NME}.${FILE_EXTDEST}"

if [ "$TYPE" = "mp4-copy" ]; then
    ffmpeg -y -i "$2" -c copy "${FILE_DIR}/${FILE_NME}.mp4"
elif [ "$TYPE" = "mp4-1080" ]; then
    ffmpeg -y -i "$2" -vf scale=-1:1080 -c:v libx264 -crf 0 -preset slow -c:a copy "${FILE_DIR}/${FILE_NME}.mp4"
elif [ "$TYPE" = "mp4-720" ]; then
    ffmpeg -y -i "$2" -vf scale=-1:720 -c:v libx264 -crf 0 -preset medium -c:a copy "${FILE_DIR}/${FILE_NME}.mp4"
elif [ "$TYPE" = "mp4-480" ]; then
    ffmpeg -y -i "$2" -vf scale=-1:480 -c:v libx264 -crf 0 -preset fast -c:a copy "${FILE_DIR}/${FILE_NME}.mp4"
elif [ "$TYPE" = "mp4-360" ]; then
    ffmpeg -y -i "$2" -vf scale=-1:360 -c:v libx264 -crf 0 -preset veryfast -c:a copy "${FILE_DIR}/${FILE_NME}.mp4"
elif [ "$TYPE" = "mp5" ]; then
    zenity --info --text="Transcoding will occur in the background"
    ffmpeg -y -i "$2" -c:v libx265 -c:a copy "${FILE_DIR}/${FILE_NME}.mp4"
elif [ "$TYPE" = "mp2" ]; then
    ffmpeg -y -i "$2" -target pal-dvd -q:v 10 "${FILE_DIR}/${FILE_NME}.mpeg"
elif [ "$TYPE" = "webm" ]; then
    zenity --info --text="Transcoding will occur in the background"
    ffmpeg -i "$2" -b:v 0 -crf 30 -pass 1 -an -f webm -y /dev/null
    ffmpeg -i "$2" -b:v 0 -crf 30 -pass 2 "${FILE_DIR}/${FILE_NME}.webm"
elif [ "$TYPE" = "webm-mp4" ]; then
    zenity --info --text="Transcoding will occur in the background"
    ffmpeg -i "$2" -movflags faststart -profile:v high -level 4.2 "${FILE_DIR}/${FILE_NME}.mp4"
fi

echo "75" ; sleep 1
echo "# Completed ${FILE_NME}.${FILE_EXTDEST}"
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