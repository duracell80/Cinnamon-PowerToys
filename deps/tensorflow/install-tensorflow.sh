#!/bin/bash

CWD=$(pwd)

git clone https://github.com/tensorflow/examples

sudo apt install -y libbz2-dev libffi-dev libssl-dev libssl3 liblzma-dev lzma

wget -nc https://www.python.org/ftp/python/3.9.7/Python-3.9.7.tgz
tar -xvzf Python-3.9.7.tgz

cd "${CWD}/Python-3.9.7"
./configure --enable-optimizations
sudo make
sudo make altinstall
python3.9 -c 'import ssl'

if [ -d "${CWD}/examples/modelmaker" ]; then
	python3.9 -m venv modelmaker
fi

source "${CWD}/examples/modelmaker/bin/activate"
mkdir -p "${CWD}/examples/modelmaker/app"

cd "${CWD}/examples/tensorflow_examples/lite/model_maker/pip_package"
pip install -e .

chmod +x $CWD/deps/*.sh
chmod +x $CWD/deps/*.py

cp -f $CWD/deps/*.sh $CWD/examples/modelmaker/app
cp -f $CWD/deps/*.py $CWD/examples/modelmaker/app

