#!/bin/bash

CWD=$(pwd)
NME="moondream"
ENV="${NME}-venv"
PTH="${CWD}/${NME}"
APP="${PTH}/${ENV}/app"
BIN="${PTH}/${ENV}/bin"

#sudo apt install lzma

git clone https://github.com/vikhyat/moondream.git $NME && cd $NME

python3.9 -m venv "${PTH}/${ENV}"
source "${BIN}/activate" && mkdir -p "${APP}"

pip install -r "${PTH}/requirements.txt"

cp "${PTH}/sample.py" "${APP}"
chmod +x "${APP}/sample.py"
