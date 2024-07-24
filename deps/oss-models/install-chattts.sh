#!/bin/bash

CWD=$(pwd)
NME="chattts"
ENV="${NME}-venv"
PTH="${CWD}/${NME}"
APP="${PTH}/${ENV}/app"
BIN="${PTH}/${ENV}/bin"
BIH="${HOME}/.local/bin"
INS="${HOME}/.local/share/oss-models/${NME}"
APH="${INS}/app"

sudo apt install nvidia-cuda-toolkit

mkdir -p "${HOME}/Audio/TTS"

echo "[i] Installing ${NME} from GIT"

if [ -d "${PTH}" ]; then
	cd $NME
	git fetch
	git pull
	cd ../
else
	git clone https://github.com/2noise/ChatTTS $NME
fi
cd "${PTH}" && chmod +x "${PTH}/setup.py"

echo "[i] Creating Python VENV"
python3.10 -m venv "${PTH}/${ENV}"
source "${BIN}/activate" && mkdir -p "${APP}"

pip install -r "${PTH}/requirements.txt"

deactivate
#pip install nvidia-cublas-cu11 nvidia-cudnn-cu11

#pip install git+https://github.com/NVIDIA/TransformerEngine.git@stable

#export LD_LIBRARY_PATH=`python3 -c 'import os; import nvidia.cublas.lib; import nvidia.cudnn.lib; print(os.path.dirname(nvidia.cublas.lib.__file__) + ":" + os.path.dirname(nvidia.cudnn.lib.__file__))'`
#export CUDA_HOME=/usr/local/cuda-X.X



#mkdir -p $HOME/.local/share/oss-models/$NME
rm -rf "${HOME}/.local/share/oss-models/${NME}"
mv -f "${PTH}/${ENV}" "${INS}"

cp -r "${PTH}/ChatTTS" "${APH}"
cp -f "${CWD}/scripts/chattts/chattts-test.py" "${APH}"

#cp -f "${CWD}/scripts/chattts/main.py" "${APH}/main.py"
#cp -f "${CWD}/scripts/chattts/main.sh" "${APH}/app/main.sh"

#echo "[i] Running a test generation ..."
#source "${INS}/bin/activate"
#python3 "${APH}/chattts-test.py"
#deactivate

#chmod +x "${APH}/main.sh"
#chmod +x "${APH}/main.py"

#cp "${CWD}/scripts/${NME}/main.sh" "${BIH}/${NME}"
#cp "${CWD}/scripts/${NME}/whisper-transcribe.sh" "${BIH}/${NME}-transcribe"
#chmod +x "${BIH}/${NME}"

#cp -f "${CWD}/../../nemo/actions/pt-caption-media.nemo_action" "${HOME}/.local/share/nemo/actions"
#cp -f "${CWD}/../../scripts/caption_mediafiles.sh" "${HOME}/.local/share/powertoys"



echo "[i] Done!"
