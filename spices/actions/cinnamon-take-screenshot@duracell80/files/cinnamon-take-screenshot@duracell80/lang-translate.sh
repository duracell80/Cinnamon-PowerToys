#!/bin/bash

# GET THE USERS LANGUAGE
#LANG=$(locale | grep LANGUAGE | cut -d= -f2 | cut -d_ -f1)
#LANG="fr"

# TAKE FROM COMMAND LINE PARAMS
LANG="${1}"

# AVAILABLE LANGUAGES
#https://en.wikipedia.org/wiki/ISO_639-1

# DEBIAN BASED COMMAND DETECTION
if ! [ -x "$(which translate-cli)" ]; then
        echo "[i] Translator Module Not Found; Supply sudo password to install git and translate-cli ..."
        sudo apt install git
	mkdir -p deps
	cd deps
	git clone https://github.com/terryyin/translate-python
	cd translate-python
	sudo python3 setup.py install
fi



# SOURCE LANGUAGE, DON'T OVERWRITE THIS, USE THIS FILE TO CREATE SOURCE TRANSLATION
LANGS="en"
LANGS_OUT=("da" "de" "en" "es" "fi" "fr" "hu" "it" "nn" "pt" "ru" "tr")



for LANG in ${LANGS_OUT[@]}; do
	# SKIP SOURCE LANGUAGE
	if [ "${LANG,,}" != "${LANGS,,}" ]; then

		# UI LANG: ENGLISH
		MSG01="\n[i] Done"
		MSG00="\n[i] Generating translation ... en -> ${LANG}\n\n"

		# REMOVE EXISTING DESTINATION FILE
		rm -f "./po-sh/lang_${LANG,,}.txt"; echo -e "${MSG00}"
		touch "./po-sh/lang_${LANG,,}.txt"

		# CHECK FOR SOURCE TRANSLATION FILE
		if [ -f "./po-sh/lang_${LANGS,,}.txt" ]; then
		        while read line
		        do
                		IFS=';' read -ra col <<< "$line"

		                suffix="${col[0]}"
		                declare $suffix="${col[1]}"
				echo -e "Source: ${col[1]}"

				if [ "${LANG}" != "${LANGS}" ]; then
					LANGT=$(translate-cli -t "${LANG}" "${col[1]}" -o); echo "${suffix};${LANGT}" >> "./po-sh/lang_${LANG,,}.txt"
					echo -e "Output: ${LANGT}\n\n"
				fi

		        done < "./po-sh/lang_${LANGS,,}.txt"
		else
			echo "[!] Source language file doesn't exist (lang_${LANG})"
		fi
	fi
	#echo "[i] Resting the API for a minute or two ..."
	#sleep 30

done



echo -e "${MSG01}"
#sudo dpkg-reconfigure locales
