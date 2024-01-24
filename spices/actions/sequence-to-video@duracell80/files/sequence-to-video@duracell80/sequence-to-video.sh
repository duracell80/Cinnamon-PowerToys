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
    TIC=$(date +%c | sed 's/:/-/g' | sed 's/ /-/g')

    touch "${DIR_TGT}/ffseq-${TIS}.txt"
    

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
            "05" "Filename random" \
            "06" "File modified (ascending)" \
            "07" "File modified (descending)" )

    if [ "$SORT" = "01" ]; then
        # LOWER TO HIGHER
        SORTED=($(sort -f <(printf "%s\n" "$@")))
        MARKER="ascending"

    elif [ "$SORT" = "02" ]; then
        # HIGHER TO LOWER
        SORTED=($(sort -fr <(printf "%s\n" "$@")))
        MARKER="descending"

    elif [ "$SORT" = "03" ]; then
        # UNIQUE ASC        
        SORTED=($(sort -fu <(printf "%s\n" "$@")))
        MARKER="unique-ascending"

    elif [ "$SORT" = "04" ]; then
        # UNIQUE DESC    
        SORTED=($(sort -fur <(printf "%s\n" "$@")))
        MARKER="unique-descending"

    elif [ "$SORT" = "05" ]; then
        # RANDOM
        SORTED=($(sort -fR <(printf "%s\n" "$@")))
        MARKER="random"

    elif [ "$SORT" = "06" ] || [ "$SORT" = "07" ]; then
        # FILE MODIFIED DATE
        INFILE=($(printf "%s\n" "$@"))
        BUCKET=()

        for f in "${INFILE[@]}"; do
            FILE_MOD=$(date -r "${f}" +%s)
            BUCKET+=("${FILE_MOD}:${f}")
        done

            if [ "$SORT" = "06" ]; then
                # ASC            
                SORTED=($(sort <(printf "%s\n" "${BUCKET[@]}")))
                MARKER="modified-ascending"
            elif [ "$SORT" = "07" ]; then
                # DESC
                SORTED=($(sort -r <(printf "%s\n" "${BUCKET[@]}")))
                MARKER="modified-descending"      
            fi

        for s in "${SORTED[@]}"; do
            IFS=':' read -ra f <<< "$s"    
            echo "file '${f[1]}'" >> "${DIR_TGT}/ffseq-${TIS}.txt"
        done

    else
        # USER HITS CANCEL            
        exit        
    fi

    for f in "${SORTED[@]}"; do
        echo "file '${f}'" >> "${DIR_TGT}/ffseq-${TIS}.txt"
    done


    # COMBINE IMAGES WITH TEXT FILE AS PLAYLIST
    ffmpeg -r 30 -f concat -safe 0 -i "${DIR_TGT}/ffseq-${TIS}.txt" -c:v libx264 -pix_fmt yuv420p "${DIR_TGT}/sequence-${MARKER}-${TIC,,}.mp4"   
    if [[ $(compgen -c | grep -iw 'ffmpeg' | head -n1 | wc -l) > "0" ]]; then    
        celluloid ${DIR_TGT}/sequence-${MARKER}-${TIC,,}.mp4
    fi    
    rm -f "${DIR_TGT}/ffseq-${TIS}.txt"
fi
