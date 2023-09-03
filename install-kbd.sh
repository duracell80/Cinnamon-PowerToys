#!/bin/bash

# Combination of scripts and service that runs once on startup to determine ambient light levels
# Uses fswebcam to gain light levels and does not store or transmit any image gained

CWD=$(pwd)
LWD=$HOME/.local/share/powertoys
LBD=$HOME/.local/bin
USR=/usr/bin

NME="set_backlight"

# Inspect the script set_backlight.sh and ambientlight before using
read -p "This script uses fswebcam if wanting to sense ambient light levels. Answer no to install without light sensing? (yes/no) " yn

case $yn in
	yes)
	sudo apt install fswebcam imagemagick

	sudo cp -f $CWD/scripts/$NME.sh $USR/$NME.sh
	sudo chmod +x $USR/$NME.sh

	sudo cp $CWD/scripts/ambientlight.py $USR/ambientlight
	sudo chmod a+x $USR/ambientlight

	sudo cp $CWD/autostart/$NME-ambient.service /etc/systemd/system
	sudo chmod 644 /etc/systemd/system/$NME-ambient.service

	# Disables the non ambient service
        sudo systemctl stop $NME.service
        sudo systemctl disable $NME.service

	# Enables the ambient service
	sudo systemctl enable $NME-ambient.service
	sudo systemctl start $NME-ambient.service

	exit
	;;
	no)
	sudo cp -f $CWD/scripts/$NME.sh $USR/$NME.sh
        sudo chmod +x $USR/$NME.sh

        sudo cp $CWD/autostart/$NME.service /etc/systemd/system
        sudo chmod 644 /etc/systemd/system/$NME.service

	# Enables the simple on service
        sudo systemctl enable $NME.service
        sudo systemctl start $NME.service

	# Disables the ambient service (stops the webcam access on boot)
	sudo systemctl stop $NME-ambient.service
	sudo systemctl disable $NME-ambient.service

	exit
	;;
	* ) echo "invalid response";
		exit 1;;
esac
