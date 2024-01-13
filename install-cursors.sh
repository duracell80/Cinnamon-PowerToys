#!/bin/bash

CWD=$(pwd)
LWD=$HOME/.local/share/powertoys
LBD=$HOME/.local/bin

export PATH=$LBD:$PATH

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

sudo cp -r XCursor-Pro-Dark /usr/share/icons
sudo cp -r XCursor-Pro-Light /usr/share/icons


if [ ! -d "$HOME/git/BreezeX_Cursor" ]; then
        mkdir -p $HOME/git && cd $HOME/git
        git clone https://github.com/ful1e5/BreezeX_Cursor.git
fi


cd $HOME/git/BreezeX_Cursor
./release.sh

cd $HOME/git/BreezeX_Cursor/bin
tar -xvf BreezeX-Light.tar.gz
tar -xvf BreezeX-Dark.tar.gz

sudo cp -r BreezeX-Dark /usr/share/icons
sudo cp -r BreezeX-Light /usr/share/icons


gsettings set org.cinnamon.desktop.interface cursor-theme 'XCursor-Pro-Light'
gsettings set org.gnome.desktop.interface cursor-theme 'XCursor-Pro-Light'
gsettings set x.dm.slick-greeter cursor-theme-name 'XCursor-Pro-Light'

gsettings set x.dm.slick-greeter icon-theme-name 'Minty-Grey'
gsettings set x.dm.slick-greeter theme-name 'Minty-Grey'

sudo update-alternatives --config x-cursor-theme
