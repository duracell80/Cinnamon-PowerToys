#!/bin/bash
#sudo apt install acpi zenity redshift
#pip3 install pypexels pexels pexels_api requests tqdm

CWD=$(pwd)
LWD=$HOME/.local/share/powertoys 

mkdir -p $LWD

cp -f $CWD/scripts/watch_battery.sh $LWD
cp -f $CWD/scripts/watch_power.sh $LWD

cp -f $CWD/scripts/extract_chapters_mkv.sh $LWD

# COPY NEMO SCRIPTS AND ACTIONS
cp -f $CWD/nemo/actions/pt-extract-chapters-mkv.nemo_action $CWD/nemo/actions/pt-extract-chapters-mkv.nemo_action.tmp
sed -i "s|Exec=~/|Exec=$HOME/|g" $CWD/nemo/actions/pt-extract-chapters-mkv.nemo_action.tmp

mv $CWD/nemo/actions/pt-extract-chapters-mkv.nemo_action.tmp $HOME/.local/share/nemo/actions/pt-extract-chapters-mkv.nemo_action


#cp -f $CWD/nemo/actions/*.nemo_action $HOME/.local/share/nemo/actions
cp -rf $CWD/nemo/scripts $HOME/.local/share/nemo

# SET ANY AUTOSTART SCRIPTS FOR DESKTOP ENVIRONMENT
cp -f $CWD/autostart/*.desktop $HOME/.config/autostart