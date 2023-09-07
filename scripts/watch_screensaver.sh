#!/bin/bash

STATE_TX="${HOME}/.local/state/screensaver/status.txt"
SFILE_BG="${HOME}/.local/state/screensaver/bg_restore.txt"
SFILE_LK="${HOME}/.local/state/screensaver/bg_lock.txt"

$HOME/.local/share/powertoys/blur.py

if [ -x "$(which cinnamon-screensaver)" ]; then
	while true
	do
		if [ ! -f $FILE_LK ]; then
			echo $(gsettings get x.dm.slick-greeter background) > $HOME/.local/state/screensaver/bg_lock.txt
		fi
        #cinnamon-screensaver-command -q > $STATE_TX
	#STATE_SS=$(cat $STATE_TX)

        STATE_SS=$(cinnamon-screensaver-command -q)
	if [[ $STATE_SS == *"inactive"* ]]; then
		STATE_RS=$(cat $SFILE_BG)
		STATE_LK=$(cat $SFILE_LK)
		STATE_BG=$(gsettings get org.cinnamon.desktop.background picture-uri | tr -d "'")

		if [[ $STATE_BG == $STATE_LK ]]; then
			gsettings set org.cinnamon.desktop.background picture-uri $STATE_RS
		fi
	fi
	sleep 2
	done
fi
