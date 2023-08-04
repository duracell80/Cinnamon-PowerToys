#!/bin/bash

CWD=$(pwd)
LWD=$HOME/.local/share/powertoys
LBD=$HOME/.local/bin


if ! [ -x "$(which mainline)" ]; then
    sudo apt update
    sudo add-apt-repository ppa:cappelikan/ppa
    sudo apt-update
    sudo apt install mainline
fi

mainline --install-latest

neofetch
echo "[i] Please reboot ..."
