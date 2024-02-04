#!/bin/bash

CWD=$(pwd)
NME="moondream"
ENV="${NME}-venv"
PTH="${CWD}/${NME}"
APP="${PTH}/${ENV}/app"
BIN="${PTH}/${ENV}/bin"

#sudo apt install lzma

echo "[i] Installing Moondream from GIT"

git clone https://github.com/vikhyat/moondream.git $NME
cd "${PTH}" && chmod +x "${PTH}/sample.py"

echo "[i] Creating Python VENV"
python3.9 -m venv "${PTH}/${ENV}"
source "${BIN}/activate" && mkdir -p "${APP}"

pip install -r "${PTH}/requirements.txt"

echo "[i] Running a test description ..."
python3 "${PTH}/sample.py" --image="${CWD}/media/test.jpg" --prompt="describe this image"

cp -r "${PTH}/moondream" "${APP}"
cp "${PTH}/sample.py" "${APP}/main.py"
cp "${CWD}/scripts/${NME}-main.sh" "${APP}/main.sh"
cp "${CWD}/scripts/${NME}-main.sh" "${HOME}/.local/bin/moondream"

chmod +x "${APP}/*.sh"
chmod +x "${APP}/*.py"

echo "[i] Moving Python VENV to local share folder"


mkdir -p $HOME/.local/share/oss-models
rm -rf "${HOME}/.local/share/oss-models"
mv -f "${PTH}/${ENV}" "${HOME}/.local/share/oss-models/${NME}"

echo "[i] Done!"
