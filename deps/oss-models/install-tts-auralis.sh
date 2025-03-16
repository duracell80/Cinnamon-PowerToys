#!/bin/bash

CWD=$(pwd)
NME="auralis-tts"
ENV="${NME}-venv"
PTH="${CWD}/${NME}"
APP="${PTH}/${ENV}/app"
BIN="${PTH}/${ENV}/bin"
BIH="${HOME}/.local/bin"
INS="${HOME}/.local/share/oss-models/${NME}"
APH="${INS}/app"
APB="${INS}/bin"
AUD="${HOME}/Audio/TTS/Auralis"

sudo apt install git

mkdir -p "${AUD}/.voices"

echo "[i] Installing ${NME} from GIT - Version 0.1.1"
if [ -d "${PTH}" ]; then
	cd $NME
	git fetch
	git pull
	cd ../
else
	git clone https://github.com/astramind-ai/Auralis.git $NME
fi
#cd "${PTH}" && chmod +x "${PTH}/setup.py"

echo "[i] Creating Python VENV"
python3.10 -m venv "${INS}"
python3.10 -m ensurepip
source "${APB}/activate" && mkdir -p "${APH}"

pip install auralis

#pip install nvidia-cublas-cu11 nvidia-cudnn-cu11
#pip install git+https://github.com/NVIDIA/TransformerEngine.git@stable
#export LD_LIBRARY_PATH=`python3 -c 'import os; import nvidia.cublas.lib; import nvidia.cudnn.lib; print(os.path.dirname(nvidia.cublas.lib.__file__) + ":" + os.path.dirname(nvidia.cudnn.lib.__file__))'`
#export CUDA_HOME=/usr/local/cuda-X.X

cp -f "${CWD}/scripts/auralistts/main.py" "${APH}"
cp -f "${CWD}/scripts/auralistts/reference.wav" "${AUD}/.voices/reference-test.wav"
cp -f "${CWD}/scripts/auralistts/reference.wav" "${AUD}/.voices"

#echo "[i] Running a test generation ..."
chmod +x "${APH}/main.py"

cd "${APH}"
$APH/main.py
deactivate
play $HOME/Audio/TTS/Auralis/test-auralis.wav
cd "${CWD}"


echo "[i] Done!"
