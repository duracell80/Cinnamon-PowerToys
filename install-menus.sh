#!/bin/bash

CWD=$(pwd)
LWD=$HOME/.local/share/powertoys
LBD=$HOME/.local/bin

if ! [ -x "$(which rofi)" ]; then
    sudo apt install rofi
fi

if ! [ -x "$(which pip)" ]; then
	sudo apt install pip
else
	pip install xdisplayinfo
fi

sudo cp -f $CWD/fonts/rofi/* /usr/share/fonts/ && fc-cache -f
cp -rf $CWD/scripts/rofi $LWD
