#!/bin/bash

cd ../
CWD=$(pwd)
sudo apt update
sudo apt install wget build-essential python3-setuptools zlib1g-dev libncurses5-dev libgdbm-dev libnss3-dev libssl-dev libssl3 libreadline-dev libffi-dev lzma liblzma-dev libsqlite3-dev wget libbz2-dev libsqlite3-dev sqlite3 sqlite3-tools tk-dev python3-pip python3-wheel uuid-dev uuid



wget -nc https://www.python.org/ftp/python/3.12.9/Python-3.12.9.tgz
tar -xvzf Python-3.12.9.tgz

cd "${CWD}/Python-3.12.9"
./configure --enable-optimizations --prefix=$HOME/opt/python-3.12.9

sudo make -j 2
sudo make altinstall

export PATH=$HOME/opt/python-3.12.9/bin:$PATH
source ~/.profile

python3.12 -c 'import ssl'

#Add this to ~/.profile or ~/.bash_profile
# export PATH=$HOME/opt/python-3.12.9/bin:$PATH
