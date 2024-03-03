#!/bin/bash
# Copy filename of currently selected file
# @git:duracell80


# ENVIRONMENT VARS
DIR_PWD=$(pwd)

FILE_NAME=$(basename $1)
FILE_PART=${FILE_NAME%.*}
FILE_EXTN=${FILE_NAME##*.}

DISP_TYPE=$(loginctl show-session `loginctl|grep $(whoami)|awk '{print $1}'` -p Type | cut -d "=" -f2)

if [[ $DISP_TYPE == "x11" ]]; then
    echo "${FILE_NAME}" | xclip -selection c
else
    echo "Wayland support coming"
    # elif [[ $DISP_TYPE == "wayland" ]]; then    
    #wl-clipboard
fi
