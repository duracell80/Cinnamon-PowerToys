#!/bin/bash

CWD=$(pwd)
NME="moondream"
ENV="${NME}-venv"
PTH="${CWD}/${NME}"
APP="${PTH}/${ENV}/app"
BIN="${PTH}/${ENV}/bin"

#sudo apt install lzma

git clone https://github.com/vikhyat/moondream.git $NME
cd "${PTH}" && chmod +x "${PTH}/sample.py"

python3.9 -m venv "${PTH}/${ENV}"
source "${BIN}/activate" && mkdir -p "${APP}"

pip install -r "${PTH}/requirements.txt"
python3 "${PTH}/sample.py" --image="${CWD}/media/test.jpg" --prompt="describe this image"

cp -r "${PTH}/moondream" "${APP}"
cp "${PTH}/sample.py" "${APP}"
