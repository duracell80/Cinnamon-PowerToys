#!/bin/bash

CWD=$(pwd)
LWD=$HOME/.local/share/powertoys
LBD=$HOME/.local/bin

export PATH=$LBD:$PATH

mkdir -p $LWD
touch $HOME/.cache/hypnotix/providers/hd-homerun

if ! [ -x "$(which hdhomerun_config)" ]; then
  sudo apt install -y git automake autoconf

    rm -rf cd $CWD/deps/libhdhomerun
    mkdir -p $CWD/deps

    cd $CWD/deps
    git clone https://github.com/Silicondust/libhdhomerun.git
    cd $CWD/deps/libhdhomerun
    autoconf
    ./configure
    make
    sudo make install
    cp $CWD/deps/libhdhomerun/hdhomerun_config $LBD
    cd $CWD

fi

cp $CWD/scripts/hdhr_channels.py $LWD/
cp $CWD/scripts/hypnotix_hdhr.sh $LWD/

chmod +x $LWD/hdhr_channels.py
chmod +x $LWD/hypnotix_hdhr.sh


source $HOME/.profile


$LWD/hdhr_channels.py
$LWD/hypnotix_hdhr.sh


#if wget -q --method=HEAD http://hdhomerun.local; then
#    echo "[i] Found HDHomeRun Tuners on this network"
#    echo "[i] Visit http://hdhomerun.local in a browser"
#else
#    echo "[i] There are no HDHomeRun tuners on this network"
#    echo "[i] Visit https://info.hdhomerun.com for more details"
#fi
