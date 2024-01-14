#!/bin/bash
# Manage previous Linux Mint Backgrounds from the desktop
# @git:duracell80

USR=$(whoami)
LWD=$HOME/Pictures
CWD=$HOME/.local/share/powertoys

BACK_GET=($(apt list | grep -i "mint-backgrounds" | cut -d '-' -f3 | cut -d '/' -f1))
BACK_GOT=$(apt list | grep -i "mint-backgrounds" | grep -i "installed" | cut -d '-' -f3 | cut -d '/' -f1)

# CHECK IF USER HAS SUDO GROUP
if [ -z "$(groups ${USR} | grep sudo)" ]; then
	zenity --error --icon-name=security-high-symbolic --text="Without sudo rights you're not able to install packages with apt, add sudo group to your user account (usermod -aG sudo ${USER})"
	exit
fi

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

SESAME=`zenity --password --icon-name=security-high-symbolic --width=500 --title="Sudo password needed for apt"`
case $? in
         0)
	 	(
		# INSTALL BACKGROUNDS THAT ARE CHECKED
		echo "15"
		sudo  -S <<< $SESAME apt -y install $PKGI
		echo "25"
		# UNINSTALL BACKGROUNDS THAT ARE UNCHECKED
		if [[ "${PKGU}" -ne "" ]]; then
			sudo -S <<< $SESAME apt -y remove $PKGU
		else
			sleep 1
		fi
		echo "50"; sleep 0.5
		echo "75"; sleep 0.5
		echo "85"; sleep 0.5
		notify-send --urgency=normal --icon=cs-backgrounds-symbolic "Nemo Action Completed - Previous Backgrounds" "The following packages are now available:\n\n${PKGI}"
		echo "100"
		cinnamon-settings backgrounds
		) | zenity --progress --title="Making chosen backgrounds available" --text="Installing Previous Mint Backgrounds\n\n${PKGI}" --percentage=0 --width=500 --timeout=180

		;;
         1)
                zenity --error --icon-name=security-high-symbolic --text="Password not entered, exiting";;
        -1)
                zenity --error --icon-name=dialog-error-symbolic --text="An unexpected error has occurred";;
esac
