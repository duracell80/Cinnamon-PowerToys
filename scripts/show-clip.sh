#!/bin/sh

/usr/bin/xclip -o > /tmp/clip.txt && zenity --text-info --title="Clipboard Contents" --filename=/tmp/clip.txt
