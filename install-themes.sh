#!/bin/bash

CWD=$(pwd)
LWD=$HOME/.local/share/powertoys
LBD=$HOME/.local/bin
LTD=$HOME/.themes

sudo apt remove mint-l-theme
sudo apt install sassc inkscape optipng

if [ ! -d "$HOME/git/mint-themes" ]; then
        git clone https://github.com/linuxmint/mint-themes.git
fi
