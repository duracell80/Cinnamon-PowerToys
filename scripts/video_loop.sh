#!/bin/bash
PID_CURR=$$
DIR_INSTALL=$HOME/.local/bin
DIR_LOOPSIE=$HOME/Videos/Wallpapers

mkdir -p $DIR_LOOPSIE
touch $DIR_LOOPSIE/current_tmp.mp4
touch $DIR_LOOPSIE/current.mp4

(
echo "25"
echo "# Pausing any current video wallpapers"
video-wallpaper.sh --pause

sleep 2

echo "35"
echo "# Converting to MP4 (max video duration 15 seconds)"
ffmpeg -y -t 15 -i "$1" -c:v copy -an -r 30 "${DIR_LOOPSIE}/current_tmp.mp4"
sleep 2

echo "50"
echo "# Boomerang-ing the video (please be patient)"
ffmpeg -y -i "${DIR_LOOPSIE}/current_tmp.mp4" -s 1920x1080 -c:v libx264 -filter_complex "[0]reverse[r];[0][r]concat=n=2:v=1:a=0" -an -r 30 "${DIR_LOOPSIE}/current.mp4"

echo "75" ; sleep 1
rm -f "${DIR_LOOPSIE}/current_tmp.mp4"
echo "100" ; sleep 1
echo "# Completed!"
$DIR_INSTALL/video-wallpaper.sh --start "${DIR_LOOPSIE}/current.mp4"

) |
zenity --progress \
  --title="Converting to Video Wallpaper" \
  --text="Preparing video as a boomerang ..." \
  --auto-kill \
  --percentage=15 \
  --width=500

if [ "$?" = -1 ] ; then
    zenity --error --text="Action canceled"
