#!/bin/bash
# Manage previous Linux Mint Backgrounds from the desktop
# @git:duracell80

# CHECK IF SYSTEM IS DEBIAN
DIS="non"
UNM=$(uname -a)


if [[ "${UNM,,}" == *"debian"* ]]; then
        DIS="deb"
elif [[ "${UNM,,}" == *"ubuntu"* ]]; then
        DIS="deb"
elif [[ "${UNM,,}" == *"ubuntu-cinnamon"* ]]; then
        DIS="deb"
elif [[ "${UNM,,}" == *"fedora"* ]]; then
	#FEDORA
        DIS="rpm"
elif [[ "${UNM,,}" == *"fc"* ]]; then
        # FEDORA
	DIS="rpm"
else
	# CHECK IF SYSTEM HAS APT
        if [[ $(compgen -c | grep -iw 'apt' | head -n1 | wc -c) == "0" ]]; then
                DIS="non"
        fi
fi

# CHECK IF SYSTEM HAS MINT PACKAGES
PKGF=$HOME/.cache/current.repos.list
if [ ! -f $PKGF ]; then
        grep -h ^deb /etc/apt/sources.list /etc/apt/sources.list.d/* >> $PKGF
fi

USR=$(whoami)


# GET THE USERS LANGUAGE AND REGION VARIANT
LANG=$(locale | grep LANGUAGE | cut -d= -f2 | cut -d_ -f2)
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

# UKRAINIAN
elif [ "${REGI,,}" = "ru_ua" ]; then
        export LC_ALL="ru_UA.utf-8"
        LANG_INS="установлен"
	LANG="ru"

# RUSSIAN
elif [ "${LANG,,}" = "ru" ]; then
        export LC_ALL="ru_RU.utf-8"
        LANG_INS="установлен"

# AMERICAN
elif [ "${LANG,,}" = "us" ]; then
        export LC_ALL="en_US.utf-8"
        LANG_INS="installed"

else
	export LC_ALL="en_US.utf-8"
	LANG_INS="installed"
fi

if [[ "${DIS,,}" == "deb" ]]; then
	BACK_GET=($(apt list | grep -i "mint-backgrounds" | cut -d '-' -f3 | cut -d '/' -f1))
	BACK_GOT=$(apt list | grep -i "mint-backgrounds" | grep -i "${LANG_INS}" | cut -d '-' -f3 | cut -d '/' -f1)
fi

#PO-EN
LAN00="Apt Information: mint-background packages not available, add linux mint packages your apt sources or install manually from"
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
	done < "lang_${LANG,,}.txt"
fi

# CHECK IF USER HAS SUDO GROUP
if [[ "${DIS,,}" = "deb" ]]; then
	if [ -z "$(groups ${USR} | grep sudo)" ]; then
		zenity --error --icon-name=security-high-symbolic --text="${LAN01} (usermod -aG sudo ${USER})"
		exit
	fi
fi

# DEAL WITH NON-MINT SYSTEMS (eg Ubuntu Cinnamon and Fedora / Arch without apt/dpkg)
if [ -f $PKGF ]; then
        PKGC=$(cat $PKGF | grep -i "linuxmint_main" | wc -c)
        if [ "${PKGC}" = "0" ]; then
                zenity --error --icon-name=security-high-symbolic --text="${LAN00} http://packages.linuxmint.com/pool/main/m/"

		# CHECK IF SYSTEM HAS CURL
		if [[ $(compgen -c | grep -iw 'curl' | head -n1 | wc -c) == "0" ]]; then
		        SESAME=`zenity --password --icon-name=security-high-symbolic --width=500 --title="Install Curl"`

			# DEAL WITH MISSING CURL BASED ON DISTRIBUTION TO MAXIMIZE NON-MINT USAGE
			if [ "${DIS}" = "deb" ]; then
		        	sudo -S <<< $SESAME apt update
		        	sudo -S <<< $SESAME apt install -y curl
			elif [ "${DIS}" = "rpm" ]; then
				sudo -S <<< $SESAME dnf install -y curl
			else
				exit
			fi
		fi

                # LOOKUP PACKAGES FROM MINT REPO
                BACK_GET=($(curl -s "http://packages.linuxmint.com/pool/main/m/" | grep -i "mint-backgrounds" | cut -d "-" -f3 | cut -d "/" -f1))
        fi
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


		if [ "${PKGC}" = "0" ]; then
       			# PREPARE FOR SYSTEM BEING NON-MINT
			echo "30"
			DIR_DWN="${HOME}/Downloads/mint-backgrounds"
			DIR_TGT="/usr/share/backgrounds"

			mkdir -p $DIR_DWN
			sudo -S <<< $SESAME mkdir -p $DIR_TGT
		        IFS=' ' read -r -a PKGW <<< "$PKGN"


			# SINCE PACKAGES ONLY SOURCED FROM MINT GET THE ARCHIVES IF THERE IS NO APT
                        if [[ $(compgen -c | grep -iw 'apt' | head -n1 | wc -c) == "0" ]]; then


				for d in "${PKGW[@]}"
                                do
					echo "35"
					# IF ARCHIVE ALREADY IN DOWNLOADS, SKIP DOWNLOAD
					if ! [ -f "${DIR_DWN}/${d,,}.tar.gz" ]; then
						PKGF=$(curl -s "http://packages.linuxmint.com/pool/main/m/mint-backgrounds-${d,,}/" | grep -i ".tar.gz" | cut -d ">" -f3 | cut -d '"' -f2)
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
					echo "45"

                                done
			# BUT IF APT IS AVAILABLE AND NON-MINT/DEBIAN SYSTEMS MAKE PACKAGE MANAGEMENT THE BETTER CHOICE
			else
				for d in "${PKGW[@]}"
       				do
               				if ! [ -f "${DIR_DWN}/${d,,}.deb" ]; then
                       				PKGF=$(curl -s "http://packages.linuxmint.com/pool/main/m/mint-backgrounds-${d,,}/" | grep -i ".deb" | cut -d ">" -f3 | cut -d '"' -f2)
                       				curl -o "${DIR_DWN}/${d,,}.deb" "http://packages.linuxmint.com/pool/main/m/mint-backgrounds-${d}/${PKGF,,}"

	                       			sudo -S <<< $SESAME apt install "${DIR_DWN}/${d,,}.deb" > /dev/null 2>&1
        	       			fi
       				done
			fi
		else
			# SYSTEM IS VERY LIKELY NATIVE MINT OK TO USE PACKAGES BY NAME
			sudo -S <<< $SESAME apt -y install $PKGI > /dev/null 2>&1
		fi



		echo "55"
		# UNINSTALL BACKGROUNDS THAT ARE UNCHECKED
		sudo -S <<< $SESAME apt -y remove $PKGU > /dev/null 2>&1
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
