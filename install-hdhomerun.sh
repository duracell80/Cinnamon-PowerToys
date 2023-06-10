#!/bin/bash

sudo apt install -y git

#if wget -q --method=HEAD http://hdhomerun.local; then
    CWD=$(pwd)
    LWD=$HOME/.local/share/powertoys
    LBD=$HOME/.local/bin

    mkdir -p $CWD/deps

    cd $CWD/deps 
    git clone https://github.com/Silicondust/libhdhomerun.git
    cd $CWD/deps/libhdhomerun
    ./configure
    make
    sudo make install
    cp $CWD/deps/libhdhomerun/hdhomerun_config $LBD
    cd $CWD
#else
#    echo "[i] There are no HDHomeRun tuners on this network"
#    echo "[i] Visit https://info.hdhomerun.com for more details"
#fi
