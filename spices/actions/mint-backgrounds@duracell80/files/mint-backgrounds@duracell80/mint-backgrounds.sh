#!/bin/bash
# Manage previous Linux Mint Backgrounds from the desktop
# @git:duracell80

USR=$(whoami)

# GET THE USERS LANGUAGE
LANG=$(locale | grep LANGUAGE | cut -d= -f2 | cut -d_ -f2)
REGI=$(locale | grep LANGUAGE | cut -d= -f2)
#LANG="fr"

# FRENCH
if [ "${LANG,,}" = "fr" ]; then
	export LC_ALL="fr_FR.utf-8"
	LANG_INS="installé"

# SPANISH
elif [ "${LANG,,}" = "es" ]; then
        export LC_ALL="es_ES.utf-8"
        LANG_INS="instalado" #fem instalada

# PORTUGUESE - BRAZIL
elif [ "${REGI,,}" = "pt_br" ]; then
        export LC_ALL="pt_BR.utf-8"
        LANG_INS="instalado" #fem instalada
	LANG="pt"

# PORTUGUESE
elif [ "${LANG,,}" = "pt" ]; then
        export LC_ALL="pt_PT.utf-8"
        LANG_INS="instalado" #fem instalada

# GERMAN
elif [ "${LANG,,}" = "de" ]; then
        export LC_ALL="de_DE.utf-8"
        LANG_INS="installiert"

# ITALIAN
elif [ "${LANG,,}" = "it" ]; then
        export LC_ALL="it_IT.utf-8"
        LANG_INS="installato"

# DANISH
elif [ "${LANG,,}" = "da" ]; then
        export LC_ALL="da_DK.utf-8"
        LANG_INS="installeret"

# FINNISH
elif [ "${LANG,,}" = "fi" ]; then
        export LC_ALL="fi_FI.utf-8"
        LANG_INS="asennettu"

# NORWEGIAN NYNORSK
elif [ "${LANG,,}" = "nn" ]; then
        export LC_ALL="nn_NO.utf-8"
        LANG_INS="installed"

# HUNGARIAN
elif [ "${LANG,,}" = "hu" ]; then
        export LC_ALL="hu_HU.utf-8"
        LANG_INS="telepítve"

# TURKISH
elif [ "${LANG,,}" = "tr" ]; then
        export LC_ALL="tr_TR.utf-8"
        LANG_INS="kurulu"

# UKRAINIAN
elif [ "${REGI,,}" = "ru_ua" ]; then
        export LC_ALL="ru_UA.utf-8"
        LANG_INS="установлен"
	LANG="ru"

# RUSSIAN
elif [ "${LANG,,}" = "ru" ]; then
        export LC_ALL="ru_RU.utf-8"
        LANG_INS="установлен"

else
	export LC_ALL="en_US.utf-8"
	LANG_INS="installed"
fi

BACK_GET=($(apt list | grep -i "mint-backgrounds" | cut -d '-' -f3 | cut -d '/' -f1))
BACK_GOT=$(apt list | grep -i "mint-backgrounds" | grep -i "${LANG_INS}" | cut -d '-' -f3 | cut -d '/' -f1)



#PO-EN
LAN01="Without sudo rights you're not able to install packages with apt, add sudo group to your user account"
LAN02="Choose packages to install or remove"
LAN03="Import"
LAN04="Background Set"
LAN05="Index"

LAN20="Sudo password needed for apt"
LAN21="Nemo Action Completed - Previous Backgrounds"
LAN22="The following packages are now available"
LAN23="Making chosen backgrounds available"
LAN24="Installing Previous Mint Backgrounds"

LAN60="Password not entered, exiting"
LAN90="An unexpected error has occurred"

if [ "${LANG}" != "en" ]; then
	while read line
	do
   		IFS=';' read -ra col <<< "$line"

		suffix="${col[0]}"
		declare $suffix="${col[1]}"
	done < "lang_${LANG}.txt"
fi



# CHECK IF USER HAS SUDO GROUP
if [ -z "$(groups ${USR} | grep sudo)" ]; then
	zenity --error --icon-name=security-high-symbolic --text="${LAN01} (usermod -aG sudo ${USER})"
	exit
fi

ZCMD='zenity \
	--list \
	--checklist \
	--width=500 \
	--height=300 \
	--title="${LAN02}" \
	--column="${LAN03}" --column="${LAN04}" --column="${LAN05}" '


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

SESAME=`zenity --password --icon-name=security-high-symbolic --width=500 --title="${LAN20}"`
case $? in
         0)
	 	(
		# INSTALL BACKGROUNDS THAT ARE CHECKED
		echo "15"
		sudo  -S <<< $SESAME apt -y install $PKGI
		echo "25"
		# UNINSTALL BACKGROUNDS THAT ARE UNCHECKED
		sudo -S <<< $SESAME apt -y remove $PKGU
		echo "50"; sleep 0.5
		echo "75"; sleep 0.5
		echo "85"; sleep 0.5
			notify-send 	--urgency=normal \
					--icon=cs-backgrounds-symbolic "${LAN21}" "${LAN22}:\n\n${PKGI}"
		echo "100"
		cinnamon-settings backgrounds
		) | zenity 	--progress \
				--title="${LAN23}" \
				--text="${LAN24}\n\n${PKGI}" \
				--percentage=15 --width=500 --timeout=180

		;;
         1)
                zenity --error --icon-name=security-high-symbolic --text="${LAN60}";;
        -1)
                zenity --error --icon-name=dialog-error-symbolic --text="${LAN90}";;
esac
