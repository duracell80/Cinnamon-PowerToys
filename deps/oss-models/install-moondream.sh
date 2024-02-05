#!/bin/bash

CWD=$(pwd)
NME="moondream"
ENV="${NME}-venv"
PTH="${CWD}/${NME}"
APP="${PTH}/${ENV}/app"
BIN="${PTH}/${ENV}/bin"
BIH="${HOME}/.local/bin"
INS="${HOME}/.local/share/oss-models/${NME}"
APH="${INS}/app"

#sudo apt install lzma

echo "[i] Installing Moondream from GIT"

if [ -d "${PTH}" ]; then
	cd $NME
	git fetch
	git pull
	cd ../
else
	git clone https://github.com/vikhyat/moondream.git $NME
fi
cd "${PTH}" && chmod +x "${PTH}/sample.py"

echo "[i] Creating Python VENV"
python3.9 -m venv "${PTH}/${ENV}"
source "${BIN}/activate" && mkdir -p "${APP}"

pip install wheel
pip install -r "${PTH}/requirements.txt"

echo "[i] Running a test description ..."
python3 "${PTH}/sample.py" --image="${CWD}/media/test.jpg" --prompt="describe this image"

cp -r "${PTH}/moondream" "${APP}"
cp "${CWD}/scripts/moondream-main.py" "${APP}/main.py"


echo "[i] Moving Python VENV to local share folder"


mkdir -p $HOME/.local/share/oss-models
rm -rf "${HOME}/.local/share/oss-models/${NME}"
mv -f "${PTH}/${ENV}" "${INS}"

cp "${CWD}/scripts/${NME}-main.sh" "${INS}/app/main.sh"
cp "${CWD}/scripts/${NME}-main.sh" "${BIH}/${NME}"

chmod +x "${APH}/main.sh"
chmod +x "${APH}/main.py"

cp -f "${CWD}/../../nemo/actions/pt-describe-images.nemo_action" "${HOME}/.local/share/nemo/actions"
cp -f "${CWD}/../../nemo/actions/pt-describe-image.nemo_action" "${HOME}/.local/share/nemo/actions"

cp -f "${CWD}/../../scripts/describe_images.sh" "${HOME}/.local/share/powertoys"
cp -f "${CWD}/../../scripts/describe_image.sh" "${HOME}/.local/share/powertoys"
cp -f "${CWD}/../../scripts/describe_llava.py" "${HOME}/.local/share/powertoys"
#cp -f "${CWD}/../../nemo/actions/pt-describe-image-${NME,,}.nemo_action" "${HOME}/.local/share/nemo/actions"

echo "[i] Done!"
