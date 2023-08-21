#!/bin/bash

CWD=$(pwd)
LWD=$HOME/.local/share/powertoys
LBD=$HOME/.local/bin
USR=/usr/bin

NME="set_backlight"

sudo cp $CWD/scripts/$NME.sh $USR/$NME.sh
sudo chmod +x $USR/$NME.sh

sudo cp $CWD/autostart/$NME.service /etc/systemd/system
sudo chmod 644 /etc/systemd/system/$NME.service

sudo systemctl enable $NME.service
sudo systemctl start $NME.service
