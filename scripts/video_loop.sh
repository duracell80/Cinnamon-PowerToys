#!/bin/bash

DIR_INSTALL=$HOME/.local/bin
DIR_LOOPSIE=$HOME/Videos/Wallpapers

mkdir -p $DIR_LOOPSIE
touch $DIR_LOOPSIE/current.mp4

(
echo "25"
echo "# Stopping any current video wallpapers from playing"
video-wallpaper.sh --pause

sleep 2

echo "50"
echo "# Boomerang Video Rendering for GPU Video Wallpaper"

ffmpeg -y -i $1 -s 1920x1080 -c:v libx264 -filter_complex "[0]reverse[r];[0][r]concat=n=2:v=1:a=0" -an -r 30 "${DIR_LOOPSIE}/current.mp4"

echo "75" ; sleep 1
echo "100" ; sleep 1
echo "# Completed!"
$DIR_INSTALL/video-wallpaper.sh --start "${DIR_LOOPSIE}/current.mp4"

) |
zenity --progress \
  --title="Converting to Video Wallpaper (Please Be Patient)" \
  --text="Preparing video as a boomerang ..." \
  --percentage=15 \
  --width=500

if [ "$?" = -1 ] ; then
        zenity --error \
          --text="Action canceled"
