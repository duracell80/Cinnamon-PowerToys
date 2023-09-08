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

mkdir -p $LWD/rofi/themes
cp -rf $CWD/scripts/rofi $LWD
cp -f $CWD/scripts/blur.py $LWD

sudo cp -f $CWD/fonts/rofi/* /usr/share/fonts/ && fc-cache -f


sudo cp -f $CWD/scripts/lock-screen.py /usr/bin/lock-screen
sudo chmod a+x /usr/bin/lock-screen
sudo cp -f $CWD/scripts/lock-screen-blur.py /usr/bin/lock-screen-blur
sudo chmod a+x /usr/bin/lock-screen-blur

sudo cp -f $CWD/scripts/rofi/pt_power.sh /usr/bin/pt_power
sudo chmod a+x /usr/bin/pt_power

$CWD/scripts/blur.py
