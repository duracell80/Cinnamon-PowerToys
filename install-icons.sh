#!/bin/bash

CWD=$(pwd)
LWD=$HOME/.local/share/powertoys
LBD=$HOME/.local/bin
ICO=$HOME/.icons


mkdir -p $ICO
mkdir -p $HOME/git

cd $HOME/git

if ! [ -x "$(which git)" ]; then
    sudo apt install git
fi

if [ ! -d "$HOME/git/Shade-of-Z" ]; then
	git clone https://github.com/SethStormR/Shade-of-Z.git
fi

cd $HOME/git/Shade-of-Z
tar -xf "Shade of Z - Black.tar.xz"
tar -xf "Shade of Z - White.tar.xz"

mv -f "Shade of Z - Black" $ICO
mv -f "Shade of Z - White" $ICO
