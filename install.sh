#!/bin/bash
#sudo apt install acpi zenity redshift tesseract-ocr exiftool xdotool wmctrl
#pip3 install opencv-python matplotlib pypexels pexels pexels_api requests tqdm python-resize-image

CWD=$(pwd)
LWD=$HOME/.local/share/powertoys 

mkdir -p $LWD

cp -f $CWD/scripts/*.sh $LWD
cp -f $CWD/scripts/*.py $LWD

# COPY NEMO SCRIPTS AND ACTIONS
#cp -f $CWD/nemo/actions/*.nemo_action $HOME/.local/share/nemo/actions
#cp -rf $CWD/nemo/scripts $HOME/.local/share/nemo

for filename in $CWD/nemo/actions/*.nemo_action; do
    [ -e "$filename" ] || continue
    file=$(echo $filename | sed -e "s|${CWD}/nemo/actions/||g")
    
    cp -f $filename $file.tmp
    sed -i "s|Exec=~/|Exec=$HOME/|g" $file.tmp
    mv $file.tmp $HOME/.local/share/nemo/actions/$file
done





# SET ANY AUTOSTART SCRIPTS FOR DESKTOP ENVIRONMENT
for filename in $CWD/autostart/*.desktop; do
    [ -e "$filename" ] || continue
    file=$(echo $filename | sed -e "s|${CWD}/autostart/||g")
    
    cp -f "$filename" "$file.tmp"
    sed -i "s|Exec=~/|Exec=$HOME/|g" "$file.tmp"
    mv "$file.tmp" "$HOME/.config/autostart/$file"
done

#cp -f $CWD/autostart/*.desktop $HOME/.config/autostart
