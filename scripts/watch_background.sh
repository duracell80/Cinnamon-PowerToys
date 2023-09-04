#!/bin/bash
STATE_FILE="${HOME}/.local/state/background/wallpaper_current.txt"

if [ -x "$(which gsettings)" ]; then

    mkdir -p "${HOME}/.local/state/background" && touch "${STATE_FILE}"
    FILE_BLUR="${HOME}/.local/share/powertoys/user_bg_blur.jpg"

    CUR=$(gsettings get org.cinnamon.desktop.background picture-uri) && echo $CUR > "${STATE_FILE}"

	while true
	do
        CUR=$(gsettings get org.cinnamon.desktop.background picture-uri)
        PAS=$(cat "${STATE_FILE}")
            
        if [ "$PAS" != "$CUR" ]; then
            echo $CUR > "${STATE_FILE}"
            echo "[i] Background wallpaper changed"
        fi
    sleep 30
    done

fi
