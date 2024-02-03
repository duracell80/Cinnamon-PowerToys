#!/bin/bash

cd ../
CWD=$(pwd)

sudo apt install -y libbz2-dev libffi-dev libssl-dev libssl3 lzma liblzma-dev

wget -nc https://www.python.org/ftp/python/3.9.7/Python-3.9.7.tgz
tar -xvzf Python-3.9.7.tgz

cd "${CWD}/Python-3.9.7"
./configure --enable-optimizations
sudo make
sudo make altinstall
python3.9 -c 'import ssl'
