#!/bin/bash

CWD=$(pwd)
LWD=$HOME/.local/share/powertoys
LBD=$HOME/.local/bin
FNT=/usr/share/fonts
FNF=$FNT/truetype
FNL=$HOME/.fonts
FNI=$HOME/fonts/google
CFG=$FNI/googlefonts.conf
FND_BIN=$(echo $PATH | grep -i "~/.local/bin" | wc -l)



# Google Fonts
declare -a ofl=("acme" "actor" "anton" "notosans" "jost" "tektur" "caveat" "ibmplexmono" "preahvihear" "indieflower" "russoone" "tirotamil" "orbitron" "cinzel" "alfaslabone" "exo" "kalam" "greatvibes" "bungeespice" "gloriahallelujah" "sacramento" "gruppo" "pressstart2p" "tangerine" "literata" "grandifloraone" "monoton" "sharetechmono" "athiti" "audiowide" "anonymouspro" "nothingyoucoulddo" "vt323" "librebarcode39" "cutivemono" "dmmono" "wallpoet" "jetbrainsmono" "nanumbrushscript" "tenaliramakrishna" "darkergrotesque" "graduate" "alegreyasc" "brunoacesc" "manjari" "delius" "telex" "turretroad" "nixieone" "silkscreen" "mallanna" "cabin" "notable" "ralewaydots" "vastshadow" "codystar" "numans" "himelody" "flowcircular" "fasterone" "librebarcode39text" "wireone" "monofett" "iceland" "molle" "yomogi" "moul" "zillaslabhighlight" "nosifer" "plaster" "swankyandmoomoo" "notosanssignwriting" "waterfall" "notosanssymbols" "amiriquran" "ballet" "notocoloremoji" "notoemoji" "notosanslisu" "spacegrotesk" "borel" "rem" "opensans" "lato" "poppins" "raleway" "lisubosa" "playfairdisplay" "merriweather" "handjet" "quicksand" "titilliumweb" "librefranklin" "librebaskerville" "josefinsans" "edusabeginner" "bebasneue")
declare -a apa=("roboto" "robotomono" "robotoslab" "syncopate" "yellowtail")





if [[ $FND_BIN == 0 ]]; then
	mkdir -p $HOME/.local/bin
	PATH="$HOME/.local/bin:$PATH"
fi

if ! [ -x "$(which git)" ]; then
    sudo apt install git
fi


if ! [ -x "$(which pip)" ]; then
    sudo apt install pip
fi
pip install googlefonts-installer
cp -f $CWD/scripts/googlefonts_installer.py $HOME/.local/lib/python3.10/site-packages/




mkdir -p $FNI && cd $FNI
mkdir -p $FNL
echo "ufl/ubuntu" > $CFG
for i in "${ofl[@]}"
do
	echo "ofl/${i}" >> $CFG
done

for i in "${apa[@]}"
do
        echo "apache/${i}" >> $CFG
done


$LBD/googlefonts-installer

echo "[i] Processing downloaded fonts, please wait ..."
sleep 20


for i in "${ofl[@]}"
do
	sudo mkdir -p $FNF/$i
	sudo cp $FNI/ofl/$i/*.ttf $FNF/$i
	#sudo cp $FNI/ofl/$i/.uuid $FNF/$i
done

for i in "${apa[@]}"
do
        sudo mkdir -p $FNF/$i
        sudo cp $FNI/apache/$i/*.ttf $FNF/$i
        #sudo cp $FNI/apache/$i/.uuid $FNF/$i
done


# Microsoft Fonts
if ! [ -x "$(which ttf-mscorefonts-installer)" ]; then
	sudo apt install ttf-mscorefonts-installer
fi
