#!/bin/bash

APP="${HOME}/.local/share/oss-models/whisper"

if [[ "${1}" = "" ]]; then
	echo "Please supply path to mediafile"
	exit
fi

FILE_FUL=$(basename "${1}")
FILE_DIR=$(dirname "${1}")
FILE_EXT="${FILE_FUL##*.}"

FILE_NME="${FILE_FUL%.*}"


mkdir -p "${FILE_DIR}/.meta"

if [[ ! -f "${FILE_DIR}/.meta/${FILE_NME}.txt" ]]; then

	if [[ "${FILE_EXT}" == "mp3" ]]; then
		cp -f "${1}" "${FILE_DIR}/.meta/${FILE_NME}.mp3"
	else
		ffmpeg -hide_banner -loglevel error -y -i "${1}" -b:a 192K -vn "${FILE_DIR}/${FILE_NME}.mp3"
	fi

	source "${APP}/bin/activate"
	export LD_LIBRARY_PATH=`python3 -c 'import os; import nvidia.cublas.lib; import nvidia.cudnn.lib; print(os.path.dirname(nvidia.cublas.lib.__file__) + ":" + os.path.dirname(nvidia.cudnn.lib.__file__))'`

	bash -c "${APP}/bin/python3 ${APP}/app/main.py --model=medium.en --file='${FILE_DIR}/${FILE_NME}.mp3'"
	deactivate

	rm -f "${FILE_DIR}/${FILE_NME}.mp3"

	if [[ -f "${FILE_DIR}/${FILE_NME}.srt" ]]; then
		cat "${FILE_DIR}/${FILE_NME}.srt"
	fi

	if [[ -f "${FILE_DIR}/${FILE_NME}_summary.txt" ]]; then
                cat "${FILE_DIR}/${FILE_NME}_summary.txt"
        fi
else
	if [[ -f "${FILE_DIR}//${FILE_NME}.srt" ]]; then
                cat "${FILE_DIR}/${FILE_NME}.srt"
        fi

	if [[ -f "${FILE_DIR}/${FILE_NME}_summary.txt" ]]; then
                cat "${FILE_DIR}/${FILE_NME}_summary.txt"
        fi

fi
