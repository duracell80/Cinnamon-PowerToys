#!/bin/bash

CWD=$(pwd)
LWD=$HOME/.local/share/powertoys
LBD=$HOME/.local/bin

# Display Link
CNT_APT=$(apt list displaylink-driver | grep -1 "installed" | wc -l)

if [[ $CNT_APT == "2" ]]; then
	echo "[i] DisplayLink already setup, remember to reboot before hooking up to a DisplayLink Dock"
else
	FILE=$HOME/Downloads/synaptics-repository-keyring.deb
        cd $HOME/Downloads
        wget https://www.synaptics.com/sites/default/files/Ubuntu/pool/stable/main/all/synaptics-repository-keyring.deb

        sudo apt install $HOME/Downloads/synaptics-repository-keyring.deb
        sudo apt update
        sudo apt install displaylink-driver
	#firefox "https://www.amazon.com/s?k=displaylink+dock&crid=1GPJOYQBEGLRQ&sprefix=displaylink+dock%2Caps%2C101&ref=nb_sb_noss_1"

fi
