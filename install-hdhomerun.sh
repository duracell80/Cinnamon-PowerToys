#!/bin/bash

CWD=$(pwd)
LWD=$HOME/.local/share/powertoys
LBD=$HOME/.local/bin

mkdir -p $CWD/deps

cd $CWD/deps 
git clone https://github.com/Silicondust/libhdhomerun.git
cd $CWD/deps/libhdhomerun
make
cd $CWD