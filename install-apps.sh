#!/bin/bash

CWD=$(pwd)
LWD=$HOME/.local/share/powertoys
LBD=$HOME/.local/bin


if ! [ -x "$(which cinnamon)" ]; then
	echo "[i] Cinnamon Desktop Not Found"
	exit
else
	sudo apt update
	sudo apt install -y wget git
	mkdir -p $CWD/apps
	cd $CWD/apps

	git clone https://github.com/linuxmint/cinnamon-spices-applets.git
fi

gsettings set com.linuxmint.updates auto-update-cinnamon-spices false
#cinnamon-spice-updater --update-all

cd $CWD
# Unsplash Wallpapers
cd $HOME/Downloads
wget -nc "https://github.com/soroushchehresa/unsplash-wallpapers/releases/download/v1.3.0/unsplash-wallpapers_1.3.0_amd64.deb"
sudo dpkg -i $HOME/Downloads/unsplash-wallpapers_1.3.0_amd64.deb

cd $CWD

cinnamon-install-spice applet $CWD/apps/cinnamon-spices-applets/radio@driglu4it
cinnamon-install-spice applet $CWD/apps/cinnamon-spices-applets/weather@mockturtl
cinnamon-install-spice applet $CWD/apps/cinnamon-spices-applets/cinnamon-timer@jake1164
cinnamon-install-spice applet $CWD/apps/cinnamon-spices-applets/sshconnect@foobar-beer

cinnamon-settings applets
