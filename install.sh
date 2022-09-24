#!/bin/bash
#sudo apt install acpi zenity redshift
#pip3 install pypexels pexels pexels_api requests tqdm

CWD=$(pwd)
LWD=$HOME/.local/share/powertoys 

mkdir -p $LWD

cp -f $CWD/scripts/watch_battery.sh $LWD
cp -f $CWD/scripts/watch_power.sh $LWD


# SET ANY AUTOSTART SCRIPTS FOR DESKTOP ENVIRONMENT
cp -f $CWD/autostart/*.desktop $HOME/.config/autostart