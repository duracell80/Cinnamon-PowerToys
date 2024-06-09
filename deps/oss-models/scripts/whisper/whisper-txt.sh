#!/bin/bash

APP="${HOME}/.local/share/oss-models/whisper"

if [[ "${1}" = "" ]]; then
	echo "Please supply path to mediafile (mp3)"
	exit
fi

FILE_FUL=$(basename "${1}")
FILE_DIR=$(dirname "${1}")
FILE_EXT="${FILE_FUL##*.}"

FILE_NME="${FILE_FUL%.*}"

mkdir -p "${FILE_DIR}/.meta"

if [[ ! -f "${FILE_DIR}/.meta/${FILE_NME}.txt" ]]; then

	source "${APP}/bin/activate"
	export LD_LIBRARY_PATH=`python3 -c 'import os; import nvidia.cublas.lib; import nvidia.cudnn.lib; print(os.path.dirname(nvidia.cublas.lib.__file__) + ":" + os.path.dirname(nvidia.cudnn.lib.__file__))'`

	bash -c "${APP}/bin/python3 ${APP}/app/main.py --model=medium.en --file='${1}'"
	deactivate

	if [[ -f "${FILE_DIR}/.meta/${FILE_NME}.srt" ]]; then
		cat "${FILE_DIR}/.meta/${FILE_NME}.srt"
	fi

	if [[ -f "${FILE_DIR}/.meta/${FILE_NME}_summary.txt" ]]; then
                cat "${FILE_DIR}/.meta/${FILE_NME}_summary.txt"
        fi
else
	if [[ -f "${FILE_DIR}/.meta/${FILE_NME}.srt" ]]; then
                cat "${FILE_DIR}/.meta/${FILE_NME}.srt"
        fi

	if [[ -f "${FILE_DIR}/.meta/${FILE_NME}_summary.txt" ]]; then
                cat "${FILE_DIR}/.meta/${FILE_NME}_summary.txt"
        fi

fi
