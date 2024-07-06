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


FILE_ALL="${FILE_DIR}/${FILE_NME}.${FILE_EXT}"


if [[ ! -f "${FILE_DIR}/.meta/archived-${FILE_NME}.txt" ]]; then

	if [[ "${FILE_EXT}" == "mkv" || "${FILE_EXT}" == "m4a" || "${FILE_EXT}" == "mp4" || "${FILE_EXT}" == "mp3" || "${FILE_EXT}" == "ogg" || "${FILE_EXT}" == "ts" || "${FILE_EXT}" == "mpg" ]]; then
		echo "[i] Transcoding: ${1}"
		ffmpeg -hide_banner -loglevel error -n -i "${FILE_ALL}" -b:a 192K -vn -ac 1 "${FILE_DIR}/archived-${FILE_NME}.mp3"
		mv "${FILE_DIR}/archived-${FILE_NME}.mp3" "${FILE_DIR}/.meta"
		mv -f "${1}" "${HOME}/.local/share/Trash/files"

	else
		exit
	fi

	if [[ -f "${FILE_DIR}/.meta/archived-${FILE_NME}.mp3" ]]; then
		source "${APP}/bin/activate"
		export LD_LIBRARY_PATH=`python3 -c 'import os; import nvidia.cublas.lib; import nvidia.cudnn.lib; print(os.path.dirname(nvidia.cublas.lib.__file__) + ":" + os.path.dirname(nvidia.cudnn.lib.__file__))'`

		bash -c "${APP}/bin/python3 ${APP}/app/main.py --model=medium.en --file='${FILE_DIR}/.meta/archived-${FILE_NME}.mp3'"
		deactivate

		if [[ -f "${FILE_DIR}/.meta/${FILE_NME}.srt" ]]; then
        	        cat "${FILE_DIR}/.meta/${FILE_NME}.srt"
        	fi

        	if [[ -f "${FILE_DIR}/.meta/${FILE_NME}_summary.txt" ]]; then
                	cat "${FILE_DIR}/.meta/${FILE_NME}_summary.txt"
        	fi

	fi
fi
