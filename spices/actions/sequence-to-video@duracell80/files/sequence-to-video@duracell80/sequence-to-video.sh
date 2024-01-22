#!/bin/bash
# Sequence a selection of images into a video with ffmpeg (stop frame animation, dashboard captures, weather or traffic cameras)
# @git:duracell80


# ENVIRONMENT VARS
DIR_PWD=$(pwd)
DIR_TGT="${1%/*}/"


# ZENITY DOESN'T SEEM TO WORK WITHOUT THIS WHEN NOT USING ENGLISH
LANG=$(locale | grep LANGUAGE | cut -d= -f2 | cut -d_ -f1)
REGI=$(locale | grep LANGUAGE | cut -d= -f2)
if [ "${LANG}" = "" ]; then
	LANG="en"
fi
export LC_ALL="${REGI}.utf-8"
# END ZENITY


if [ -f "${DIR_APP}/po-sh/lang_${LANG,,}.txt" ]; then
	while read line
	do
   		IFS=';' read -ra col <<< "$line"
		suffix="${col[0]}"
		declare $suffix="${col[1]}"
	done < "${DIR_APP}/po-sh/lang_${LANG,,}.txt"
else
	#FALL BACK ON EN
	LAN00="ffmpeg not available, exiting."
fi







# TAKE FILE SELECTION PASS TO FFMPEG AND OUTPUT SEQUENCE
if [[ $(compgen -c | grep -iw 'ffmpeg' | head -n1 | wc -l) == "0" ]]; then
    zenity --error --icon-name=security-high-symbolic --text="${LAN00}";
else
   # US date format: 2024-01-21 16:27 = +%Y-%m-%d %H:%M
   # ELSE USE UNIVERSAL SECONDS FOR FILE NAME
    TIS=$(date +%s)
    touch "${DIR_TGT}/ffseq_${TIS}.txt"
    
    for f in "$@"
    do
        echo "file '${f}'" >> "${DIR_TGT}/ffseq_${TIS}.txt"
    done

    ffmpeg -r 30 -f concat -safe 0 -i "${DIR_TGT}/ffseq_${TIS}.txt" -c:v libx264 -pix_fmt yuv420p "${DIR_TGT}/sequence_${TIS}.mp4"   
    celluloid ${DIR_TGT}/sequence_${TIS}.mp4
    rm -f "${DIR_TGT}/ffseq_${TIS}.txt"
fi
