#!/bin/bash

CWD=$(pwd)
NME="whisper"
ENV="${NME}-venv"
PTH="${CWD}/${NME}"
APP="${PTH}/${ENV}/app"
BIN="${PTH}/${ENV}/bin"
BIH="${HOME}/.local/bin"
INS="${HOME}/.local/share/oss-models/${NME}"
APH="${INS}/app"

#sudo apt install lzma

echo "[i] Installing ${NME} from GIT"

if [ -d "${PTH}" ]; then
	cd $NME
	git fetch
	git pull
	cd ../
else
	git clone https://github.com/SYSTRAN/faster-whisper.git $NME
fi
cd "${PTH}" && chmod +x "${PTH}/setup.py"

echo "[i] Creating Python VENV"
python3.9 -m venv "${PTH}/${ENV}"
source "${BIN}/activate" && mkdir -p "${APP}"

pip install wheel argparse pysubs2
pip install -r "${PTH}/requirements.txt"

cp -r "${PTH}/faster_whisper" "${APP}"

cp -f "${CWD}/scripts/whisper/whisper-test.py" "${APP}"
cp -f "${CWD}/scripts/whisper/main.py" "${APP}/main.py"
cp -f "${CWD}/scripts/whisper/main.sh" "${APP}/main.sh"
echo "[i] Running a test transcription ..."
python3 "${APP}/whisper-test.py" --cpu --model=base --audio="${CWD}/media/test.mp3"


mkdir -p $HOME/.local/share/oss-models
rm -rf "${HOME}/.local/share/oss-models/${NME}"
mv -f "${PTH}/${ENV}" "${INS}"

cp -f "${CWD}/scripts/${NME}/main.sh" "${APH}/main.sh"
cp -f "${CWD}/scripts/${NME}/main.py" "${APH}/main.py"

chmod +x "${APH}/main.sh"
chmod +x "${APH}/main.py"


echo "[i] Done!"
