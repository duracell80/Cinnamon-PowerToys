#!/bin/bash

DIR_INSTALL=$HOME/.local/bin
DIR_LOOPSIE=$HOME/Videos/Wallpapers

mkdir -p $DIR_LOOPSIE
touch $DIR_LOOPSIE/current.mp4

(
echo "50"
echo "# Creating Loopable Video for GPU Video Wallpaper!"

ffmpeg -y -i $1 -s 1920x1080 -c:v libx264 -filter_complex "[0]reverse[r];[0][r]concat=n=2:v=1:a=0" -an -r 30 "${DIR_LOOPSIE}/current.mp4"

echo "75" ; sleep 1
echo "# Completed, the change will take on thenext desktop login."
echo "100" ; sleep 1
) |
zenity --progress \
  --title="Converting to Video Wallpaper Loop" \
  --text="Running ffmpeg ..." \
  --percentage=25 \
  --width=500

if [ "$?" = -1 ] ; then
        zenity --error \
          --text="Action canceled"
