#!/bin/bash
sudo apt install acpi zenity redshift tesseract-ocr exiftool xdotool wmctrl sox jq socat mpv pcregrep xrandr python3-pyqt5 webp
pip3 install opencv-python matplotlib pypexels pexels pexels_api requests tqdm python-resize-image

CWD=$(pwd)
LWD=$HOME/.local/share/powertoys
LBD=$HOME/.local/bin

chmod u+x $CWD/*.sh

mkdir -p $HOME/.cache/powertoys
mkdir -p $CWD/deps
mkdir -p $LWD
mkdir -p $HOME/Videos/Wallpapers


cp -f $CWD/videos/wallpapers/current.mp4 $HOME/Videos/Wallpapers

# REMOVE ORIGINAL VIDEO WALLPAPER GUI
if [ -f $LBD/gui.ui ] ; then
    rm -f $LBD/gui.ui
fi

# DOWNLOAD GPU VIDEO WALLPAPER
#if [ -d $CWD/deps/gpu-video-wallpaper ] ; then
#    echo "[i] GPU Video Wallpaper Already Downloaded ... Fetching Updates"
#    cd $CWD/deps/gpu-video-wallpaper
#    git fetch
#    git pull
#    sleep 1
#else
#    echo "[i] Downloading GPU Video Wallpaper"
#    cd $CWD/deps
#    git clone https://github.com/ghostlexly/gpu-video-wallpaper.git
#    sleep 1
#fi
#cd $CWD/deps/gpu-video-wallpaper

cd $CWD/deps/gpu-video-wallpaper-fork
$CWD/deps/gpu-video-wallpaper-fork/install.sh --distro-agnostic
cd $CWD

cp -f $CWD/scripts/*.sh $LWD
cp -f $CWD/scripts/*.py $LWD

chmod u+x $LWD/*.sh
chmod u+x $LWD/*.py


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


# COPY YOUTUBE LIVE CHANNELS TO HYPNOTIX CACHE
cp -f $CWD/scripts/yt_channels.txt $HOME/.cache/hypnotix
chmod u+rw $HOME/.cache/hypnotix/yt_channels.txt

# CHECK FOR ANY HDHOMERUN TUNERS ON NETWORK FOR HYPNOTIX
if wget -q --method=HEAD http://hdhomerun.local; then
    if [ -f /usr/bin/hdhomerun_config ] ; then
        echo "[i] HDHomeRun Config Already Installed (For Hypnotix)"
    else
        echo "[i] HDHomeRun Config To Be Installed (For Hypnotix)"
        $CWD/install-hdhomerun.sh
    fi
fi



#cp -f $CWD/bin/* $LBD
