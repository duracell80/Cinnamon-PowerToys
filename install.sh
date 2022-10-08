#!/bin/bash
#sudo apt install acpi zenity redshift tesseract-ocr exiftool xdotool wmctrl sox
#pip3 install opencv-python matplotlib pypexels pexels pexels_api requests tqdm python-resize-image

CWD=$(pwd)
LWD=$HOME/.local/share/powertoys 

mkdir -p $CWD/deps
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
    sed -i "s|~/Videos|$HOME/Videos|g" "$file.tmp"
    mv -f "$file.tmp" "$HOME/.config/autostart/$file"
done

#cp -f $CWD/autostart/*.desktop $HOME/.config/autostart


# DOWNLOAD GPU VIDEO WALLPAPER
if [ -d $CWD/deps/gpu-video-wallpaper ] ; then
    echo "[i] GPU Video Wallpaper Already Downloaded ... Fetching Updates"
    cd $CWD/deps/gpu-video-wallpaper
    git fetch
    git pull
    sleep 1
else
    echo "[i] Downloading GPU Video Wallpaper"
    cd $CWD/deps
    git clone https://github.com/ghostlexly/gpu-video-wallpaper.git
    sleep 1
fi

cd $CWD/deps/gpu-video-wallpaper/
./install.sh --distro-agnostic