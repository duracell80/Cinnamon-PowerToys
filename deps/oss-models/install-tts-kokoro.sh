#!/bin/bash

CWD=$(pwd)
NME="kokoro-tts"
ENV="${NME}-venv"
PTH="${CWD}/${NME}"
APP="${PTH}/${ENV}/app"
BIN="${PTH}/${ENV}/bin"
BIH="${HOME}/.local/bin"
INS="${HOME}/.local/share/oss-models/${NME}"
APH="${INS}/app"
APB="${INS}/bin"
AUD="${HOME}/Audio/TTS/Kokoro"

sudo apt install git

mkdir -p "${AUD}/.text"
cp ${CWD}/scripts/kokorotts/test.txt ${AUD}/.text

echo "[i] Installing ${NME} from GIT - Version 0.1.1"
if [ -d "${PTH}" ]; then
	cd $NME
	git fetch
	git pull
	git reset --hard 0e2ec20
	#cd ../
else
	git clone https://github.com/nazdridoy/kokoro-tts.git $NME
	cd $NME
	git reset --hard 0e2ec20
	#cd ../

fi
cd "${PTH}"
#chmod +x "${PTH}/setup.py"

echo "[i] Creating Python VENV"
python3.12 -m venv "${INS}"
python3.12 -m ensurepip
source "${APB}/activate" && mkdir -p "${APH}"

cp -r $PTH $APH
mkdir -p $APH/kokoro-tts/static

wget -nc -O $APH/kokoro-tts/voices-v1.0.bin https://github.com/nazdridoy/kokoro-tts/releases/download/v1.0.0/voices-v1.0.bin
wget -nc -O $APH/kokoro-tts/kokoro-v1.0.onnx https://github.com/nazdridoy/kokoro-tts/releases/download/v1.0.0/kokoro-v1.0.onnx

pip install -r  "${CWD}/scripts/kokorotts/requirements_custom.txt"

echo "[i] Running a test generation ..."
cp -f "${CWD}/scripts/kokorotts/main.sh" "${BIH}/kokoro-tts"

kokoro-tts -v af_sarah -f $AUD/.text/test.txt

deactivate

source $HOME/.profile
echo "[i] Done!"
