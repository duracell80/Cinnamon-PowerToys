#!/bin/bash

CWD=$(pwd)
NME="bark"
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
	git clone https://github.com/suno-ai/bark $NME
fi
cd "${PTH}" && chmod +x "${PTH}/setup.py"

echo "[i] Creating Python VENV"
python3.10 -m venv "${PTH}/${ENV}"
source "${BIN}/activate" && mkdir -p "${APP}/.meta"

pip install wheel scipy argparse
pip install .

cp -r "${PTH}/bark" "${APP}"

cp -f "${CWD}/scripts/bark/bark-test.py" "${APP}/bark-test.py"
cp -f "${CWD}/scripts/whisper/main.py" "${APP}/main.py"
cp -f "${CWD}/scripts/whisper/main.sh" "${APP}/main.sh"
echo "[i] Running a test transformation ..."
python3 "${APP}/bark-test.py"

mkdir -p $HOME/.local/share/oss-models
rm -rf "${HOME}/.local/share/oss-models/${NME}"
mv -f "${PTH}/${ENV}" "${INS}"

cp -f "${CWD}/scripts/${NME}/main.sh" "${APH}/main.sh"
cp -f "${CWD}/scripts/${NME}/main.py" "${APH}/main.py"

chmod +x "${APH}/main.sh"
chmod +x "${APH}/main.py"

cp "${CWD}/scripts/${NME}/main.sh" "${BIH}/${NME}"
chmod +x "${BIH}/${NME}"

cp -f "${CWD}/../../nemo/actions/pt-tts-bark.nemo_action" "${HOME}/.local/share/nemo/actions"
cp -f "${CWD}/../../scripts/tts-bark.sh" "${HOME}/.local/share/powertoys"
cp -f "${CWD}/../../scripts/test.txt" "${APH}/.meta/"


echo "[i] Done!"
play "/tmp/bark_test.wav"
sleep 2
rm /tmp/bark_test.wav
