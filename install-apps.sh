#!/bin/bash

CWD=$(pwd)
LWD=$HOME/.local/share/powertoys
LBD=$HOME/.local/bin

sudo apt update

if ! [ -x "$(which cinnamon)" ]; then
	echo "[i] Cinnamon Desktop Not Found"
	exit
else
	sudo apt install -y wget git
	mkdir -p $CWD/apps
	cd $CWD/apps

	git clone https://github.com/linuxmint/cinnamon-spices-applets.git
fi

gsettings set com.linuxmint.updates auto-update-cinnamon-spices false
#cinnamon-spice-updater --update-all

if ! [ -x "$(which unsplash-wallpapers)" ]; then
	cd $HOME/Downloads
	wget -nc "https://github.com/soroushchehresa/unsplash-wallpapers/releases/download/v1.3.0/unsplash-wallpapers_1.3.0_amd64.deb"
	sudo dpkg -i $HOME/Downloads/unsplash-wallpapers_1.3.0_amd64.deb

	cd $CWD
fi

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


# PPAs

if ! [ -x "$(which obs)" ]; then

        read -p "[Q] Install OBS Studio from PPA (y/n)? " answer
	case ${answer:0:1} in
    		y|Y )
        		sudo add-apt-repository ppa:obsproject/obs-studio
                	sudo apt update
                	sudo apt -y install obs-studio
    		;;
    		* )
        		sudo add-apt-repository --remove ppa:obsproject/obs-studio
			sudo apt update
			echo "[i] OBS PPA not added"
    		;;
	esac


	if ! [ -x "$(which obs)" ]; then
		read -p "[Q] Install OBS Studio from APT (y/n)? " answer
        	case ${answer:0:1} in
                	y|Y )
                        	sudo add-apt-repository --remove ppa:obsproject/obs-studio
                        	sudo apt update
                        	sudo apt -y install obs-studio
                	;;
                	* )
                        	echo "[i] OBS APT not added"
                ;;
        	esac

	fi
fi

# Flatpak

if [ -x "$(which flatpak)" ]; then
	echo "[i] Flatpak is available on this system"

	HAVE_MC=$(flatpak list | grep -i "Mission Center" | wc -l)
	if [[ "$HAVE_MC" == "0" ]]; then
		flatpak install io.missioncenter.MissionCenter
	fi
fi

#cinnamon-settings applets
