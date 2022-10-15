#!/bin/bash
# Send to Radio++ (install cinnamon applet called Radio++ by driglu4it)
# @git:duracell80

LWD=$HOME/.cinnamon/configs/radio@driglu4it

if [ -f "$LWD/radio@driglu4it.json" ]; then
    FILE_DIR=$(dirname "$2")
    FILE_BIT=$(basename "$2")

    FILE_NME=${FILE_BIT%%.*}
    FILE_EXT=${FILE_BIT##*.}

    cp -f $LWD/radio@driglu4it.json $LWD/radio@driglu4it.json_backup
    
    # MULTIPLE STATIONS IN ONE FILE
    if [ "$1" = "multi" ]; then
        STATION_COUNT=$(grep 'http[s]*://[^/][^\\]*' "$2" | wc -l)
        STATION_FILES=(`grep 'http[s]*://[^/][^\\]*' "$2" | cut -d'=' -f2`)
        
        ZCMD="zenity --list --checklist --width=500 --height=300 --title=\"Choose stations to import\" --column=\"Import\" --column=\"Station Name\" --column=\"Station URL\" "
        
        # BUILD ZENITY CHOICE LIST
        if [ "$FILE_EXT" = "pls" ]; then
            i=0
            while [ "$i" -lt $STATION_COUNT ]; do
                
                STATION_FILE=${STATION_FILES[$i]}
                STATION_NAME=(`grep -A1 "$STATION_FILE" $2 | grep -v "$STATION_FILE" | cut -d'=' -f2`)
                
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
            
            # APPEND THE JSON
            JSON=$(jq ".tree.value[.tree.value| length] |= .+ {\"inc\":\"true\", \"name\":\"$STATION_NAME\", \"url\":\"$STATION_URL\"}" $LWD/radio@driglu4it.json)
            
            echo "${JSON}" > $LWD/radio@driglu4it.json
            i=$(( i + 1 ))
        done
        
        zenity --info --text="Added ${#STATION_NAMES[@]} new station(s) to Radio++"
    
    
    
        # END MULTIPLE STATIONS IN PLS
    
    
    
    
    
    
    else
    # SINGLE STATION BUT ALTERNATIVE URLS IN ONE FILE
        if [ "$FILE_EXT" = "pls" ]; then
            # TAKE FIRST STATION URL IN FILE
            STATION_URL=$(cat "$2" | grep 'http[s]*://[^/][^\\]*' | head -n 1 | cut -d'=' -f2)
            STATION_NAME=$(grep -A1 "$STATION_URL" $2 | grep -v "$STATION_URL" | head -n 1 | cut -d'=' -f2)
        else
            STATION_URL=""
            STATION_NAME=""
        fi
        if [ -z "$STATION_URL" ]; then
            echo "[!] Valid URL Could not be found"
            zenity --error --text="Valid URL Could not be found"
            exit
        else 
            JSON=$(jq ".tree.value[.tree.value| length] |= .+ {\"inc\":\"true\", \"name\":\"$STATION_NAME\", \"url\":\"$STATION_URL\"}" $LWD/radio@driglu4it.json)

            echo "${JSON}" > $LWD/radio@driglu4it.json
            zenity --info --text="Added ${STATION_NAME} to Radio++"
        fi
    fi
    
else
    echo "[!] Radio++ applet not installed, please install from cinnamon spices applets"
    zenity --error --text="Radio++ applet not installed, please install from cinnamon spices applets"
    exit
fi