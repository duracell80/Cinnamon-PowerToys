#!/bin/bash

APP="${HOME}/.local/share/oss-models/whisper"
source "${APP}/bin/activate"
START=$(date +%s)

if [[ "${1}" = "" ]];then
	echo "Please supply path to mediafile (mp3, oga, mp4, mkv, avi)"
	exit
fi

FILE_FUL=$(basename "${1}")
FILE_DIR=$(dirname "${1}")
FILE_EXT="${FILE_FUL##*.}"

FILE_NME="${FILE_FUL%.*}"
mkdir -p "${FILE_DIR}/.meta"

if [ ! -f "${FILE_DIR}/.meta/${FILE_NME}_audio.mp3" ]; then
	echo "25"
	ffmpeg -hide_banner -loglevel error -n -i "${1}" -b:a 192K -vn "${FILE_DIR}/.meta/${FILE_NME}_audio.mp3"
fi

if [ ! -f "${FILE_DIR}/.meta/${FILE_NME}_audio.ass" ]; then
	echo "[i] Transcribing audio"
	bash -c "${APP}/bin/python3 ${APP}/app/main.py --model=small.en --file='${FILE_DIR}/.meta/${FILE_NME}_audio.mp3'"
	echo "35"

	while IFS= read -r line
	do
        	if [[ "${line}" == *"Dialogue"* ]]; then
                	if [[ "${line:0-1}" == "." ]];then
                        	echo "${line}"
                	elif [[ "${line:0-1}" == "," ]];then
				echo "${line} ..."
			else
                        	echo "${line} ..."
                        	sed -i "s|${line}|${line} ...|g" "${FILE_DIR}/.meta/${FILE_NME}_audio.ass"
                	fi
        	fi
	done < "${FILE_DIR}/.meta/${FILE_NME}_audio.ass"

fi

echo "[i] Creating captioned media ..."
if [[ $FILE_EXT == *"oga"* ]] || [[ $FILE_EXT == *"mp3"* ]] || [[ $FILE_EXT == *"wav"* ]]; then
	if [ ! -f "${FILE_DIR}/.meta/${FILE_NME}_waveform.mp4" ]; then
		ffmpeg -hide_banner -loglevel error -y -i  "${1}" -filter_complex "aformat=channel_layouts=mono,showwaves=mode=cline:s=1280X720:colors=White[v]" -map "[v]" -pix_fmt yuv420p "${FILE_DIR}/.meta/${FILE_NME}_waveform.mp4"
		echo "45"
	fi
	ffmpeg -hide_banner -loglevel error -y -i "${1}" -i "${FILE_DIR}/.meta/${FILE_NME}_waveform.mp4" -c:v libx264 -pix_fmt yuv420p -vf scale=1280:720 -c:a copy -vf "ass=${FILE_DIR}/.meta/${FILE_NME}_audio.ass" "${FILE_DIR}/${FILE_NME}_captioned.mp4"
	echo "55"
elif [[ $FILE_EXT == *"mp4"* ]] || [[ $FILE_EXT == *"mkv"* ]] || [[ $FILE_EXT == *"avi"* ]]; then
	if [ -f "${FILE_DIR}/.meta/${FILE_NME}_audio.srt" ]; then
		ffmpeg -hide_banner -y -i "${1}" -i "${FILE_DIR}/.meta/${FILE_NME}_audio.srt" -c:s mov_text -c:v copy -c:a copy "${FILE_DIR}/${FILE_NME}_subtitled.${FILE_EXT,,}"
	fi
	if [ -f "${FILE_DIR}/.meta/${FILE_NME}_audio.ass" ]; then
                ffmpeg -hide_banner -y -i "${1}" -c:a copy -vf "ass=${FILE_DIR}/.meta/${FILE_NME}_audio.ass" "${FILE_DIR}/${FILE_NME}_captioned.mp4"
        fi
	echo "65"
fi

END=$(date +%s)
TOTAL=$(( $END - $START ))

echo "[i] Deactivating Python VENV"
deactivate

echo "[i] Total task time: ${TOTAL}s"
sleep 1
echo "75"
