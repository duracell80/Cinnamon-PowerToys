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
   
    TIS=$(date +%s)
    TIC=$(date +%c | sed 's/:/-/g' | sed 's/ /_/g')

    touch "${DIR_TGT}/ffseq_${TIS}.txt"
    

    #ASK FOR A SORTING ORDER
    SORT=$(zenity --list \
        --width=500 \
        --height=400 \
        --title="Choose a sorting method" \
        --column="Choice" --column="Description" \
            "01" "Filename ascending" \
	        "02" "Filename descending" \
            "03" "Filename unique (ascending)" \
            "04" "Filename unique (descending)" \
            "05" "Filename random" )

    if [ "$SORT" = "01" ]; then
        # LOWER TO HIGHER
        SORTED=($(sort -f <(printf "%s\n" "$@")))

    elif [ "$SORT" = "02" ]; then
        # HIGHER TO LOWER
        SORTED=($(sort -fr <(printf "%s\n" "$@")))

    elif [ "$SORT" = "03" ]; then
        # UNIQUE ASC        
        SORTED=($(sort -fu <(printf "%s\n" "$@")))

    elif [ "$SORT" = "04" ]; then
        # UNIQUE DESC    
        SORTED=($(sort -fur <(printf "%s\n" "$@")))

    elif [ "$SORT" = "05" ]; then
        # RANDOM
        SORTED=($(sort -fR <(printf "%s\n" "$@")))

    else
        # USER HITS CANCEL            
        exit        
    fi

    for f in "${SORTED[@]}"; do
        echo "file '${f}'" >> "${DIR_TGT}/ffseq_${TIS}.txt"
    done

    ffmpeg -r 30 -f concat -safe 0 -i "${DIR_TGT}/ffseq_${TIS}.txt" -c:v libx264 -pix_fmt yuv420p "${DIR_TGT}/sequence_${TIC,,}.mp4"   
    celluloid ${DIR_TGT}/sequence_${TIC,,}.mp4
    rm -f "${DIR_TGT}/ffseq_${TIS}.txt"
fi
