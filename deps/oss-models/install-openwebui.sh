#!/bin/bash

CWD=$(pwd)
NME="owui"
ENV="${NME}-venv"
PTH="${CWD}/${NME}"
APP="${PTH}/${ENV}/app"
BIN="${PTH}/${ENV}/bin"
BIH="${HOME}/.local/bin"
INS="${HOME}/.local/share/oss-models/${NME}"
APH="${INS}/app"
APB="${INS}/bin"

#sudo apt install nvidia-cuda-toolkit

mkdir -p "${HOME}/Pictures/Chat"
mkdir -p "${APH}/images/.meta"

#echo "[i] Installing ${NME} from GIT feba65f - Version 0.1.1"
#if [ -d "${PTH}" ]; then
#	cd $NME
#	git fetch
#	git pull
#	git reset --hard feba65f
#	cd ../
#else
#	git clone https://github.com/2noise/ChatTTS $NME
#	cd $NME/ChatTTS
#	git reset --hard feba65f
#	cd ../
#fi
cd "${PTH}"
#chmod +x "${PTH}/setup.py"

echo "[i] Creating Python VENV"
python3.11 -m venv "${INS}"
source "${APB}/activate" && mkdir -p "${APP}"

pip install open-webui

#pip install nvidia-cublas-cu11 nvidia-cudnn-cu11

#pip install git+https://github.com/NVIDIA/TransformerEngine.git@stable

#export LD_LIBRARY_PATH=`python3 -c 'import os; import nvidia.cublas.lib; import nvidia.cudnn.lib; print(os.path.dirname(nvidia.cublas.lib.__file__) + ":" + os.path.dirname(nvidia.cudnn.lib.__file__))'`
#export CUDA_HOME=/usr/local/cuda-X.X


mkdir -p "${APH}/OpenWebUI"

#cp -r "${PTH}/ChatTTS" "${APH}"
cp -f "${CWD}/scripts/owui/main.sh" "${BIH}/owui-start"
#cp -f "${CWD}/scripts/chattts/voices_f.txt" "${APH}"
#cp -f "${CWD}/scripts/chattts/voices_m.txt" "${APH}"
#cp -f "${CWD}/scripts/chattts/voices_t.txt" "${APH}"

#cp -f "${CWD}/scripts/flux1/demo.png" "${APH}/images/demo.png"
cp -f "${CWD}/scripts/lexi/main.py" "${APH}/main.py"
#cp -f "${CWD}/scripts/chattts/main.sh" "${APH}/app/main.sh"

#echo "[i] Running a test generation ..."
cd "${APH}"
#$APH/chattts-test.py
deactivate
#play $HOME/Audio/TTS/chattts_test.wav
#cd "${CWD}"

#chmod +x "${APH}/main.sh"
#chmod +x "${APH}/main.py"

#cp "${CWD}/scripts/${NME}/main.sh" "${BIH}/${NME}"
#cp "${CWD}/scripts/${NME}/whisper-transcribe.sh" "${BIH}/${NME}-transcribe"
#chmod +x "${BIH}/${NME}"

#cp -f "${CWD}/../../nemo/actions/pt-caption-media.nemo_action" "${HOME}/.local/share/nemo/actions"
#cp -f "${CWD}/../../scripts/caption_mediafiles.sh" "${HOME}/.local/share/powertoys"



sudo cp -f "${CWD}/scripts/owui/owui.service" /etc/systemd/system
systemctl enable owui
systemctl start owui


echo "[i] Done!"
