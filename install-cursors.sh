#!/bin/bash

CWD=$(pwd)
LWD=$HOME/.local/share/powertoys
LBD=$HOME/.local/bin

if ! [ -x "$(which yarn)" ]; then
	echo "[i] Yarn not found"
	sudo apt update
        sudo apt install -y git yarn
fi
if ! [ -x "$(which clickgen)" ]; then
	pip install clickgen
fi

if [ ! -d "$HOME/git/XCursor-pro" ]; then
	mkdir -p $HOME/git && cd $HOME/git
	git clone https://github.com/ful1e5/XCursor-pro
fi

cd $HOME/git/XCursor-pro
./release.sh

cd $HOME/git/XCursor-pro/bin
tar -xvf XCursor-Pro-Dark.tar.gz
tar -xvf XCursor-Pro-Light.tar.gz

#cp -r XCursor-Pro-Dark $HOME/.icons
#cp -r XCursor-Pro-Light $HOME/.icons

sudo cp -r XCursor-Pro-Dark /usr/share/icons
sudo cp -r XCursor-Pro-Light /usr/share/icons

gsettings set org.cinnamon.desktop.interface cursor-theme 'XCursor-Pro-Light'
gsettings set org.gnome.desktop.interface cursor-theme 'XCursor-Pro-Light'

sudo update-alternatives --config x-cursor-theme
