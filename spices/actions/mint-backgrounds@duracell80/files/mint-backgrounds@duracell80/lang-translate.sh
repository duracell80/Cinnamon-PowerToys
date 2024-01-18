#!/bin/bash

# GET THE USERS LANGUAGE
#LANG=$(locale | grep LANGUAGE | cut -d= -f2 | cut -d_ -f1)
#LANG="fr"

# TAKE FROM COMMAND LINE PARAMS
LANG="${1}"

# AVAILABLE LANGUAGES
#https://en.wikipedia.org/wiki/ISO_639-1


if ! [ -x "$(which translate-cli)" ]; then
        echo "[i] Translator Module Not Found; Supply sudo password to install git and translate-cli ..."
        sudo apt install git
	mkdir -p deps
	cd deps
	git clone https://github.com/terryyin/translate-python
	cd translate-python
	sudo python3 setup.py install
fi


# ORIGIN: ENGLISH
MSG00="[i] Generating translation ... en -> ${LANG}"
MSG01="[i] Done"

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



rm -f "lang_${LANG}.txt"; sleep 1
echo $MSG00

if [ "${LANG}" != "en" ]; then
        LAN01=$(translate-cli -t "${LANG}" "${LAN01}" -o); echo "LAN01;${LAN01}" >> "lang_${LANG}.txt"
        LAN02=$(translate-cli -t "${LANG}" "${LAN02}" -o); echo "LAN02;${LAN02}" >> "lang_${LANG}.txt"
        LAN03=$(translate-cli -t "${LANG}" "${LAN03}" -o); echo "LAN03;${LAN03}" >> "lang_${LANG}.txt"
        LAN04=$(translate-cli -t "${LANG}" "${LAN04}" -o); echo "LAN04;${LAN04}" >> "lang_${LANG}.txt"
        LAN05=$(translate-cli -t "${LANG}" "${LAN05}" -o); echo "LAN05;${LAN05}" >> "lang_${LANG}.txt"

	LAN20=$(translate-cli -t "${LANG}" "${LAN20}" -o); echo "LAN20;${LAN20}" >> "lang_${LANG}.txt"
        LAN21=$(translate-cli -t "${LANG}" "${LAN21}" -o); echo "LAN21;${LAN21}" >> "lang_${LANG}.txt"
        LAN22=$(translate-cli -t "${LANG}" "${LAN22}" -o); echo "LAN22;${LAN22}" >> "lang_${LANG}.txt"
        LAN23=$(translate-cli -t "${LANG}" "${LAN23}" -o); echo "LAN23;${LAN23}" >> "lang_${LANG}.txt"
        LAN24=$(translate-cli -t "${LANG}" "${LAN24}" -o); echo "LAN24;${LAN24}" >> "lang_${LANG}.txt"

	LAN60=$(translate-cli -t "${LANG}" "${LAN60}" -o); echo "LAN60;${LAN60}" >> "lang_${LANG}.txt"
        LAN90=$(translate-cli -t "${LANG}" "${LAN90}" -o); echo "LAN90;${LAN90}" >> "lang_${LANG}.txt"

fi

echo $MSG01

sudo dpkg-reconfigure locales
