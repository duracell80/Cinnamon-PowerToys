#!/bin/bash


CINN_VERSION=$(cinnamon --version)
CWD=$(pwd)
#LWD=$HOME/.local/share/sounds && mkdir -p $LWD
UWD=/usr/share/sounds


if [ ! -z $1 ] 
then 
    SOUND_THEME=$1
else
    SOUND_THEME="dream"
fi


set_sound () {
    SOUND_INDEX=$UWD/${2}/index.theme
    
    # READ THE CONFIG
    SOUND_FILE=$(awk -F '=' '/^\s*'${3}'\s*=/ {
        sub(/^ +/, "", $2);
        sub(/ +$/, "", $2);
        print $2;
        exit;
    }' $SOUND_INDEX)
    
    SOUND_SET=$(echo $SOUND_FILE | tr -d \'\" )
    if [ "${1}" == "cinnamon" ]; then
        if [[ "${3}" == *"volume-sound"* ]]; then
            gsettings set org.cinnamon.desktop.sound $3 $UWD/$SOUND_SET
        else
            gsettings set org.cinnamon.sounds $3 $UWD/$SOUND_SET
        fi
    fi
}

if [ -d $UWD/$SOUND_THEME ] ; then

    # IF ON CINNAMON ...
    if awk "BEGIN {exit !($CINN_VERSION > 1)}"; then
        echo "[i] - Setting sound theme for Cinnamon as ${SOUND_THEME}"
        # SOUND - FRESH DREAM
        set_sound cinnamon $SOUND_THEME "tile-file"
        set_sound cinnamon $SOUND_THEME "plug-file"
        set_sound cinnamon $SOUND_THEME "unplug-file"
        set_sound cinnamon $SOUND_THEME "close-file"
        set_sound cinnamon $SOUND_THEME "map-file"
        set_sound cinnamon $SOUND_THEME "minimize-file"
        set_sound cinnamon $SOUND_THEME "logout-file"
        set_sound cinnamon $SOUND_THEME "maximize-file"
        set_sound cinnamon $SOUND_THEME "switch-file"
        set_sound cinnamon $SOUND_THEME "notification-file"
        set_sound cinnamon $SOUND_THEME "unmaximize-file"
        set_sound cinnamon $SOUND_THEME "login-file"
        set_sound cinnamon $SOUND_THEME "volume-sound-file"
        
        gsettings set org.cinnamon.desktop.sound theme-name "${SOUND_THEME}"
    fi

else
    # IF ON CINNAMON ...
    if awk "BEGIN {exit !($CINN_VERSION > 1)}"; then
        echo "[i] Power Toys - Setting sound theme for Cinnamon as Linux Mint"
        # SOUND - LINUX MINT
        gsettings set org.cinnamon.sounds tile-file '/usr/share/sounds/LinuxMint/stereo/button-pressed.ogg'
        gsettings set org.cinnamon.sounds plug-file '/usr/share/sounds/LinuxMint/stereo/button-pressed.ogg'
        gsettings set org.cinnamon.sounds unplug-file '/usr/share/sounds/LinuxMint/stereo/button-pressed.ogg'
        gsettings set org.cinnamon.sounds close-file '/usr/share/sounds/LinuxMint/stereo/button-pressed.ogg'
        gsettings set org.cinnamon.sounds map-file '/usr/share/sounds/LinuxMint/stereo/button-pressed.ogg'
        gsettings set org.cinnamon.sounds minimize-file '/usr/share/sounds/LinuxMint/stereo/button-pressed.ogg'
        gsettings set org.cinnamon.sounds logout-file '/usr/share/sounds/LinuxMint/stereo/desktop-logout.ogg'
        gsettings set org.cinnamon.sounds maximize-file '/usr/share/sounds/LinuxMint/stereo/button-pressed.ogg'
        gsettings set org.cinnamon.sounds switch-file '/usr/share/sounds/LinuxMint/stereo/button-toggle-on.ogg'
        gsettings set org.cinnamon.sounds notification-file '/usr/share/sounds/LinuxMint/stereo/dialog-information.ogg'
        gsettings set org.cinnamon.sounds unmaximize-file '/usr/share/sounds/LinuxMint/stereo/button-pressed.ogg'
        gsettings set org.cinnamon.sounds login-file '/usr/share/sounds/LinuxMint/stereo/desktop-login.ogg'
        gsettings set org.cinnamon.desktop.sound volume-sound-file '/usr/share/sounds/LinuxMint/stereo/button-pressed.ogg'
        
        gsettings get org.cinnamon.desktop.sound theme-name 'LinuxMint'
    fi
fi