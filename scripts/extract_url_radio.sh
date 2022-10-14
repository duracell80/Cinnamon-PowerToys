#!/bin/sh

LWD=$HOME/.cinnamon/configs/radio@driglu4it

if [ -f "$LWD/radio@driglu4it.json" ]; then
    FILE_DIR=$(dirname "$1")
    FILE_BIT=$(basename "$1")

    FILE_NME=${FILE_BIT%%.*}
    FILE_EXT=${FILE_BIT##*.}

    if [ "$FILE_EXT" = "pls" ]; then
        URL=$(cat "$1" | grep 'http[s]*://[^/][^\\]*' | head -n 1 | sed 's/File1=//')
        NME=$(grep -A1 "$URL" $1 | grep -v "$URL" | head -n 1 | sed 's/Title1=//')
    else
        URL=""
        NME=""
    fi

    #echo $URL
    #echo $NME
    if [ -z "$URL" ]; then
        echo "[!] Valid URL Could not be found"
        zenity --error --text="Valid URL Could not be found"
        exit
    else
        cp -f $LWD/radio@driglu4it.json $LWD/radio@driglu4it.json_backup 
        JSON=$(jq ".tree.value[.tree.value| length] |= .+ {\"inc\":\"true\", \"name\":\"$NME\", \"url\":\"$URL\"}" $LWD/radio@driglu4it.json)
        
        echo "${JSON}" > $LWD/radio@driglu4it.json
        zenity --info --text="Added ${NME} to Radio++"
    fi
    
else
    echo "[!] Radio++ applet not installed, please install from cinnamon spices applets"
    zenity --error --text="Radio++ applet not installed, please install from cinnamon spices applets"
    exit
fi