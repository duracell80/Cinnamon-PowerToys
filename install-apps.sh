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

if ! [ -x "$(which auto-cpufreq)" ]; then
        # https://www.linuxfordevices.com/tutorials/linux/auto-cpufreq-on-linux

        printf '[Q] Install battery optimizations [auto-cpufreq] (y/n)? '
        read answer
        if [ "$answer" != "${answer#[Yy]}" ] ;then
                mkdir -p $HOME/git
                cd $HOME/git
                git clone https://github.com/AdnanHodzic/auto-cpufreq.git
                cd $HOME/git/auto-cpufreq && sudo ./auto-cpufreq-installer
        fi
else
        printf '[Q] Run battery optimizations [auto-cpufreq] (y/n)? '
        read answer
        if [ "$answer" != "${answer#[Yy]}" ] ;then
		sudo auto-cpufreq --monitor
        fi
fi



cinnamon-settings applets
