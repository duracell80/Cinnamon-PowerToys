#!/bin/bash
# Schedule an IPTV stream to dump via ffmpeg
# @git:duracell80

LWD=$HOME/Videos
CWD=$HOME/.local/share/powertoys

    FILE_DIR=$(dirname "$2")
    FILE_BIT=$(basename "$2")

    FILE_NME=${FILE_BIT%%.*}
    FILE_EXT=${FILE_BIT##*.}


    # SET RECORDING
    if [ "$1" = "set" ]; then
        STATION_COUNT=$(grep 'http[s]*://[^/][^\\]*' "$2" | wc -l)
        STATION_FILES=(`grep 'http[s]*://[^/][^\\]*' "$2" | cut -d',' -f2`)

        ZCMD="zenity --list --radiolist --width=500 --height=300 --title=\"Choose a stream to record\" --column=\"Import\" --column=\"Stream Name\" --column=\"Stream URL\" "

        # BUILD ZENITY CHOICE LIST
        if [ "$FILE_EXT" = "m3u" ] || [ "$FILE_EXT" = "m3u8" ]; then
            i=0
            while [ "$i" -lt $STATION_COUNT ]; do
                STATION_FILE=${STATION_FILES[$i]}
                STATION_NAME=$(grep -A1 "$STATION_FILE" $2 | grep -v "$STATION_FILE" | cut -d ',' -f2)

                ZCMD+=$(echo "\"-\" \"${STATION_NAME[@]}\" \"${STATION_FILE}\" ")
                i=$(( i + 1 ))
            done
        fi
        # OPEN CHOICE LIST
        ZCMD_OUT=$(eval "$ZCMD")

        # READ CHOICES
        IFS='|'; STATION_NAMES=($ZCMD_OUT); unset IFS;
        # LOOP CHOICES AND SEND TO RADIO++
        i=0
        while [ "$i" -lt ${#STATION_NAMES[@]} ]; do

            STATION_URL=(`grep -B1 "${STATION_NAMES[$i]}" $2 | grep -v "${STATION_NAMES[$i]}" | cut -d'=' -f2`)
            STATION_NAME=${STATION_NAMES[$i]}

            i=$(( i + 1 ))
        done

	ZCAL="zenity --calendar --width=500 --title \"Start Date\""
	ZCAL_OUT=$(eval "$ZCAL")

	ZTIM="zenity --entry --width=500 --title \"Start Time\" --text \"Start Time (eg 15:00 for 3pm):\" --entry-text \"15:00\""
        ZTIM_OUT=$(eval "$ZTIM")

	ZTIS="zenity --entry --width=500 --title \"Duration\" --text \"Duration in seconds (eg 3600 for an hour):\" --entry-text \"3600\""
        ZTIS_OUT=$(eval "$ZTIS")

	#202301151610
	ZDAT=$(date -d "${ZCAL_OUT} ${ZTIM_OUT}:00" +"%s")
	NDAT=$(date --date @$ZDAT +"%Y%m%d%H%M")
	CMD="${CWD}/extract_iptv_recording.sh rec ${STATION_URL} ${ZTIS_OUT}"

	echo "${CMD}" | at -t $NDAT
	zenity --info --text="Recording of stream ${STATION_NAME} is scheduled on ${ZCAL_OUT} at ${ZTIM_OUT} for ${ZTIS_OUT} seconds. Remember to leave this device hooked up to power and network connections!"



    elif [ "$1" = "rec" ]; then
	CTS=$(date "+%Y%m%d-%H%M%S")
	DIR="${HOME}/Videos/IPTV/recordings"
	mkdir -p $DIR
	ffmpeg -i $2 -c:v copy -c:a copy -t $3 $DIR/recording-$CTS.mp4
    else
            zenity --info --text="Missing mode type [set|rec]"
    fi
