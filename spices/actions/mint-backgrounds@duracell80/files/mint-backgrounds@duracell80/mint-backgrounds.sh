#!/bin/bash
# Manage previous Linux Mint Backgrounds from the desktop
# @git:duracell80


# ENVIRONMENT VARS
DIR_PWD=$(pwd)
DIR_TGT="/usr/share/backgrounds"
DIR_DWN="${HOME}/Downloads/mint-backgrounds"

if [[ "${PWD,,}" == "${HOME}" ]]; then
	DIR_APP="${HOME}/.local/share/nemo/actions/mint-backgrounds@duracell80"
else
	DIR_APP="${PWD}"
fi

# CHECK IF SYSTEM IS DEBIAN
DIS="non"
PKG="tar"
UNM=$(uname -a)


if [[ "${UNM,,}" == *"debian"* ]]; then
        DIS="deb"
	PKG="apt"
elif [[ "${UNM,,}" == *"ubuntu"* ]]; then
        DIS="deb"
	PKG="apt"
elif [[ "${UNM,,}" == *"ubuntu-cinnamon"* ]]; then
        DIS="deb"
	PKG="apt"
elif [[ "${UNM,,}" == *"fedora"* ]]; then
	#FEDORA
        DIS="non"
	PKG="dnf"
elif [[ "${UNM,,}" == *"fc"* ]]; then
    # FEDORA
	DIS="non"
	PKG="dnf"
elif [[ "${UNM,,}" == *"garuda-cinnamon"* ]]; then
    # ARCH
    DIS="non"
    PKG="pac"
elif [[ "${UNM,,}" == *"arch-linux"* ]]; then
    # ARCH
    DIS="non"
    PKG="pac"
elif [[ -f "/etc/arch-release" ]]; then
    # ARCH
    DIS="non"
    PKG="pac"
else
	DIS="non"
	PKG="tar"
	# CHECK IF SYSTEM HAS APT
        if [[ $(compgen -c | grep -iw 'apt' | head -n1 | wc -c) == "0" ]]; then
                DIS="non"
		PKG="tar"
        else
		DIS="deb"
		PKG="apt"
	fi
fi





# CHECK IF DEBIAN AND IF MINT
if [[ "${DIS,,}" == "deb" ]]; then
	PKGF=$HOME/.cache/current.repos.list
	if [ ! -f $PKGF ]; then
        	grep -h ^deb /etc/apt/sources.list /etc/apt/sources.list.d/* >> $PKGF
		PKGC=$(cat $PKGF | grep -i "linuxmint_main" | wc -c)
	else
		PKGC=$(cat $PKGF | grep -i "linuxmint_main" | wc -c)
	fi

	# FINALLY ASSURE SCRIPT IF IT HAS PACKAGE ACCESS TO MINT REPO
	if [[ "${PKGC}" == "0" ]]; then
		DIS="deb"
	else
		DIS="mnt"
	fi
fi


# GET THE USERS LANGUAGE AND REGION VARIANT
USR=$(whoami)
LANG=$(locale | grep LANGUAGE | cut -d= -f2 | cut -d_ -f1)
REGI=$(locale | grep LANGUAGE | cut -d= -f2)
if [ "${LANG}" = "" ]; then
	LANG="en"
fi

if [ "${REGI}" = "" ]; then
        REGI="US"
fi


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

# RUSSIAN
elif [ "${LANG,,}" = "ru" ]; then
        export LC_ALL="ru_RU.utf-8"
        LANG_INS="установлен"

# ENGLISH
elif [ "${LANG,,}" = "en" ]; then
        export LC_ALL="en_GB.utf-8"
        LANG_INS="installed"

else
	export LC_ALL="en_US.utf-8"
	LANG_INS="installed"
fi


# COLLECT INFORMATION ON WHAT BACKGROUNDS ARE INSTALLED ALREADY IF ANY
if [[ "${DIS,,}" == "mnt" ]] || [[ "${DIS,,}" == "deb" ]]; then
	BACK_GET=($(apt list | grep -i "mint-backgrounds" | cut -d '-' -f3 | cut -d '/' -f1))
	BACK_GOT=$(apt list | grep -i "mint-backgrounds" | grep -i "${LANG_INS}" | cut -d '-' -f3 | cut -d '/' -f1)
fi


# READ THE LANGUAGE FILE
if [ -f "${DIR_APP}/po-sh/lang_${LANG,,}.txt" ]; then
	while read line
	do
   		IFS=';' read -ra col <<< "$line"

		suffix="${col[0]}"
		declare $suffix="${col[1]}"
	done < "${DIR_APP}/po-sh/lang_${LANG,,}.txt"
else
	#notify-send "Desktop Action - Error" "[!] Language file not found"
	#XT-EN
	LAN00="Install Information: mint-background packages not available, continue to attempt to extract from archive"
	LAN01="Without sudo rights you're not able to install packages, add sudo group to your user account"
	LAN02="Choose packages to install or remove"
	LAN03="Import"
	LAN04="Background Set"
	LAN05="Index"

	LAN20="Sudo password needed for installation"
	LAN21="Desktop Action Completed - Previous Backgrounds"
	LAN22="The following packages are now available"
	LAN23="Making chosen backgrounds available"
	LAN24="Installing Mint Backgrounds"

	LAN60="Password not entered, exiting"
	LAN90="An unexpected error has occurred"

fi

# CHECK IF USER HAS SUDO GROUP
if [[ "${DIS,,}" == "mnt" ]] || [[ "${DIS,,}" == "deb" ]]; then
	if [ -z "$(groups ${USR} | grep sudo)" ]; then
		zenity --error --icon-name=security-high-symbolic --text="${LAN01} (usermod -aG sudo ${USER})"
		exit
	fi
fi

# DEAL WITH NON-MINT SYSTEMS (eg Ubuntu Cinnamon and Fedora Cinnamon)
if [[ "${DIS,,}" == "deb" ]] || [[ "${DIS,,}" == "non" ]]; then
	zenity --error --icon-name=security-high-symbolic --text="${LAN00} http://packages.linuxmint.com/pool/main/m/"

	# CHECK IF SYSTEM HAS CURL
	if [[ $(compgen -c | grep -iw 'curl' | head -n1 | wc -c) == "0" ]]; then
	        SESAME=`zenity --password --icon-name=security-high-symbolic --width=500 --title="Install Curl"`

		# DEAL WITH MISSING CURL BASED ON DISTRIBUTION TO MAXIMIZE NON-MINT USAGE
		if [ "${PKG}" = "apt" ]; then
	        	sudo -S <<< $SESAME apt update
	        	sudo -S <<< $SESAME apt install -y curl
		elif [ "${PKG}" = "dnf" ]; then
			sudo -S <<< $SESAME dnf install -y curl
        elif [ "${PKG}" = "pac" ]; then
			sudo -S <<< $SESAME pacman -Sy --noconfirm curl
		else
			exit
		fi
	fi

	# CHECK IF SYSTEM HAS NOTIFY-SEND
        if [[ $(compgen -c | grep -iw 'notify-send' | head -n1 | wc -c) == "0" ]]; then
                SESAME=`zenity --password --icon-name=security-high-symbolic --width=500 --title="Install LibNotify"`

                # DEAL WITH MISSING LIBNOTIFY BASED ON DISTRIBUTION TO MAXIMIZE NON-MINT USAGE
                if [ "${PKG}" = "deb" ]; then
                        sudo -S <<< $SESAME apt update
                        sudo -S <<< $SESAME apt install -y libnotify-bin
                elif [ "${PKG}" = "dnf" ]; then
                        sudo -S <<< $SESAME dnf install -y libnotify-bin
                elif [ "${PKG}" = "pac" ]; then
                        sudo -S <<< $SESAME pacman -Sy --noconfirm libnotify
                else
                        exit
                fi
        fi

	# LOOKUP PACKAGES FROM MINT REPO
	BACK_GOT=$(ls -d /usr/share/backgrounds/linuxmint-* | sed "s|${DIR_TGT}/linuxmint-||g" | sort -u)
	BACK_GET=($(curl -s "http://packages.linuxmint.com/pool/main/m/" | grep -i "mint-backgrounds" | cut -d "-" -f3 | cut -d "/" -f1 | sort -u))
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
PKGN=""
PKGD=""
ZCMD_OUT=$(eval "$ZCMD")
IFS='|' read -ra BACK_SET <<< "$ZCMD_OUT"

# IN/UNINSTALL
for b in "${BACK_GET[@]}"
do
    	if [[ "${ZCMD_OUT,,}" == *"${b,,}"* ]]; then
		PKGI+="mint-backgrounds-${b,,} "
		PKGN+="${b,,} "
    	else
        	PKGU+="mint-backgrounds-${b,,} "
		PKGR+="${b,,} "
    	fi
done

if [ "${PKGN}" = "" ]; then
	exit
fi

SESAME=`zenity --password --icon-name=security-high-symbolic --width=500 --title="${LAN20}"`
case $? in
         0)
	 	(
		for i in {1..20}
		do
			echo $i; sleep 0.15
		done
		# INSTALL BACKGROUNDS THAT ARE CHECKED
		echo "22"; sleep 0.5
		#sudo -S <<< $SESAME apt update > /dev/null 2>&1
		echo "25"


		if [[ "${DIS,,}" == "mnt" ]]; then
			# SYSTEM IS VERY LIKELY NATIVE MINT OK TO USE PACKAGES BY NAME
			sudo -S <<< $SESAME apt -y install $PKGI > /dev/null 2>&1

		else
			# PREPARE FOR SYSTEM BEING NON-MINT
			echo "30"

			mkdir -p $DIR_DWN
			sudo -S <<< $SESAME mkdir -p $DIR_TGT
		        IFS=' ' read -r -a PKGW <<< "$PKGN"


			# SINCE PACKAGES ONLY SOURCED FROM MINT GET THE ARCHIVES IF THERE IS NO APT
                        if [[ "${DIS,,}" == "non" ]]; then

				if ! [ -f "${HOME}/.config/cinnamon/backgrounds/user-folders.lst"]; then
                    mkdir -p "${HOME}/.config/cinnamon/backgrounds"					
                    touch "${HOME}/.config/cinnamon/backgrounds/user-folders.lst"
				fi

				for d in "${PKGW[@]}"
                                do
					echo "35"
					# IF ARCHIVE ALREADY IN DOWNLOADS, SKIP DOWNLOAD
					if ! [ -f "${DIR_DWN}/${d,,}.tar.gz" ]; then
						PKGF=$(curl -s "http://packages.linuxmint.com/pool/main/m/mint-backgrounds-${d,,}/" | grep -i ".tar.gz" | cut -d ">" -f3 | cut -d '"' -f2 | head -n1)
						curl -o "${DIR_DWN}/${d,,}.tar.gz" "http://packages.linuxmint.com/pool/main/m/mint-backgrounds-${d,,}/${PKGF,,}"
						echo "40"
					fi

					# CHECK ARCHIVE FOR STRUTURE (eg does this hav /usr base?)
					TAR2=$(tar -tf "${DIR_DWN}/${d,,}.tar.gz" | grep -i "/backgrounds/" | wc -c)
					TAR1=$(tar -tf "${DIR_DWN}/${d,,}.tar.gz" | grep -i "/usr/share/backgrounds/" | wc -c)

					if [ "${TAR1}" -gt "0" ]; then
                                                # OLD FORMAT
                                                sudo -S <<< $SESAME mkdir -p "${DIR_TGT}/linuxmint-${d,,}"
                                                sudo -S <<< $SESAME tar -xvzf "${DIR_DWN}/${d,,}.tar.gz" -C "${DIR_TGT}" --strip=4 "mint-backgrounds-${d,,}/usr/share/backgrounds/linuxmint-${d,,}/"
					elif [ "${TAR2}" -gt "0" ]; then
						# NEW FORMAT
						sudo -S <<< $SESAME mkdir -p "${DIR_TGT}/linuxmint-${d,,}"
						sudo -S <<< $SESAME tar -xvzf "${DIR_DWN}/${d,,}.tar.gz" -C "${DIR_TGT}" --strip=2 "mint-backgrounds-${d,,}/backgrounds/linuxmint-${d,,}/"
					fi

					# SET PERMISSIONS
					sudo -S <<< $SESAME chmod -R a+r "${DIR_TGT}/linuxmint-${d,,}"
					echo "45"
					echo "${DIR_TGT}/linuxmint-${d,,}" >> $HOME/.config/cinnamon/backgrounds/user-folders.lst
					sleep 0.5; echo "48"

                                done
			# BUT IF APT IS AVAILABLE AND NON-MINT/DEBIAN SYSTEMS MAKE PACKAGE MANAGEMENT THE BETTER CHOICE
			elif [[ "${DIS,,}" == "deb" ]]; then
				for d in "${PKGW[@]}"
       				do
               				if ! [ -f "${DIR_DWN}/${d,,}.deb" ]; then
                       				PKGF=$(curl -s "http://packages.linuxmint.com/pool/main/m/mint-backgrounds-${d,,}/" | grep -i ".deb" | cut -d ">" -f3 | cut -d '"' -f2)
                       				curl -o "${DIR_DWN}/${d,,}.deb" "http://packages.linuxmint.com/pool/main/m/mint-backgrounds-${d}/${PKGF,,}"

	                       			sudo -S <<< $SESAME apt install "${DIR_DWN}/${d,,}.deb" > /dev/null 2>&1
        	       			fi
       				done
			fi
		fi



		echo "55"
		# UNINSTALL BACKGROUNDS THAT ARE UNCHECKED
		if [[ "${DIS,,}" == "mnt" ]]; then
			sudo -S <<< $SESAME apt -y remove $PKGU > /dev/null 2>&1
		else
			IFS=' ' read -r -a PKRM <<< "$PKGR"
			for r in "${PKRM[@]}"
			do
				# SAFE GUARD AGAINST REMOVING ENTIRE BACKGROUNDS DIRECTORY
				# AND FURTHER SAFEGUARD FILES BY MOVING TO USERS TRASH DIRECTORY
				# RELY LESS ON VARIABLES USE DIRECT STRINGS FOR VERIFICATION
				sed -i "\|/usr/share/backgrounds/linuxmint-${r,,}|d" $HOME/.config/cinnamon/backgrounds/user-folders.lst
				if [[ -n "$r" ]]; then
					if [ -d "${HOME}/.local/share/Trash/files/mint-backgrounds" ]; then
						if [ -d "/usr/share/backgrounds/linuxmint-${r,,}" ]; then
  							if [ -d "${HOME}/.local/share/Trash/files/mint-backgrounds/linuxmint-${r,,}" ]; then
								# ITS ALREADY IN THE TRASH
								sudo -S <<< $SESAME rm -rf "/usr/share/backgrounds/linuxmint-${r,,}"
							else
								sudo -S <<< $SESAME mv -f "/usr/share/backgrounds/linuxmint-${r,,}" "${HOME}/.local/share/Trash/files/mint-backgrounds"
							fi
						fi
					else
						mkdir -p "${HOME}/.local/share/Trash/files/mint-backgrounds"
					fi

					echo "59"
				else
					# DO NOTHING IF DIRECTORY VAR IS EMPTY
					echo "60"
				fi
			done
			sort $HOME/.config/cinnamon/backgrounds/user-folders.lst | uniq > $HOME/.config/cinnamon/backgrounds/user-folders.lst.tmp && mv -f $HOME/.config/cinnamon/backgrounds/user-folders.lst.tmp $HOME/.config/cinnamon/backgrounds/user-folders.lst
			echo "62"
		fi

		echo "65"; sleep 0.5
		for i in {65..99}
                do
                        echo $i; sleep 0.15
                done

			notify-send 	--urgency=normal \
					--icon=cs-backgrounds-symbolic "${LAN21}" "${LAN22}:\n\n${PKGN}"
		echo "100"
		cinnamon-settings backgrounds
		) | zenity 	--progress \
				--title="${LAN23}" \
				--text="${LAN24}\n\n${PKGN}" \
				--width=500 --timeout=180

		;;
         1)
                zenity --error --icon-name=security-high-symbolic --text="${LAN60}";;
        -1)
                zenity --error --icon-name=dialog-error-symbolic --text="${LAN90}";;
esac
