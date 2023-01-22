#!/bin/bash
# Manage previous Linux Mint wallpapers from the desktop
# @git:duracell80

WWD=/usr/share/backgrounds
LWD=$HOME/Pictures
CWD=$HOME/.local/share/powertoys

WALL_GET=($(apt list | grep -i "mint-backgrounds" | cut -d '-' -f3 | cut -d '/' -f1))
WALL_GOT=$(apt list | grep -i "mint-backgrounds" | grep -i "installed" | cut -d '-' -f3 | cut -d '/' -f1)


ZCMD="zenity --list --checklist --width=500 --height=300 --title=\"Choose packages to install or remove\" --column=\"Import\" --column=\"Wallpaper Set\" --column=\"Index\" "

#BUILD ZENITY CHOICE LIST
i=0
while [ "$i" -lt "${#WALL_GET[@]}" ]; do
    if [[ "$WALL_GOT" == *"${WALL_GET[$i]}"* ]]; then
        t="True"
    else
        t="False"
    fi

    ZCMD+=$(echo "\"${t}\" \"${WALL_GET[$i]^}\" \"${i}\" ")
    i=$(( i + 1 ))
done


# OPEN CHOICE LIST
PKGI=""
PKGU=""
ZCMD_OUT=$(eval "$ZCMD")
IFS='|' read -ra WALL_SET <<< "$ZCMD_OUT"

# UN/INSTALL
for w in "${WALL_GET[@]}"
do
    if [[ "${ZCMD_OUT,,}" == *"${w,,}"* ]]; then
        PKGI+=" mint-backgrounds-${w,,}"
        echo "install ${w,,}"
    else
        PKGU+=" mint-backgrounds-${w,,}"
        echo "uninstall ${w,,}"
    fi
done

zenity --password --width=500 --title="Enter sudo password for apt" | sudo -S apt -y install $PKGI
sudo -S apt -y remove $PKGU

zenity --info --text="Those selections have now been added to the wallpaper selection!"