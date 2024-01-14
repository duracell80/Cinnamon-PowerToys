#!/bin/bash
# Manage previous Linux Mint Backgrounds from the desktop
# @git:duracell80

LWD=$HOME/Pictures
CWD=$HOME/.local/share/powertoys

BACK_GET=($(apt list | grep -i "mint-backgrounds" | cut -d '-' -f3 | cut -d '/' -f1))
BACK_GOT=$(apt list | grep -i "mint-backgrounds" | grep -i "installed" | cut -d '-' -f3 | cut -d '/' -f1)


ZCMD="zenity --list --checklist --width=500 --height=300 --title=\"Choose packages to install or remove\" --column=\"Import\" --column=\"Background Set\" --column=\"Index\" "

#BUILD ZENITY CHOICE LIST
i=0
while [ "$i" -lt "${#BACK_GET[@]}" ]; do
    if [[ "$BACK_GOT" == *"${BACK_GET[$i]}"* ]]; then
        t="True"
    else
        t="False"
    fi

    ZCMD+=$(echo "\"${t}\" \"${BACK_GET[$i]^}\" \"${i}\" ")
    i=$(( i + 1 ))
done


# OPEN CHOICE LIST
PKGI=""
PKGU=""
ZCMD_OUT=$(eval "$ZCMD")
IFS='|' read -ra BACK_SET <<< "$ZCMD_OUT"

# IN/UNINSTALL
for b in "${BACK_GET[@]}"
do
    if [[ "${ZCMD_OUT,,}" == *"${b,,}"* ]]; then
        PKGI+="mint-backgrounds-${b,,} "
    else
        PKGU+="mint-backgrounds-${b,,} "
    fi
done

# ASK FOR USER INPUT TO ALLOW APT TO RUN
#zenity --password --width=500 --title="Enter sudo password for apt" | sudo -S apt -y install $PKGI

SESAME=`zenity --password --width=500 --title="Enter sudo password for apt"`
case $? in
         0)
	 	(
		# INSTALL BACKGROUNDS THAT ARE CHECKED
		sudo  -S <<< $SESAME apt -y install $PKGI
		echo "50"
		# UNINSTALL BACKGROUNDS THAT ARE UNCHECKED
		sudo -S <<< $SESAME apt -y remove $PKGU
		echo "75"
		sleep 1
		echo "80"
		sleep 1
		echo "95"
		sleep 1
		notify-send --urgency=normal --icon=emblem-ok-symbolic "Nemo Action Completed - Previous Backgrounds" "The following packages are now available:\n\n${PKGI}"
		echo "100"
		) | zenity --progress --title="Making choosen backgrounds available" --text="Installing Previous Mint Backgrounds\n\n${PKGI}" --percentage=35 --width=500 --timeout=180

		;;
         1)
                zenity --error --text="Password not entered, exiting";;
        -1)
                zenity --error --text="An unexpected error has occurred";;
esac
