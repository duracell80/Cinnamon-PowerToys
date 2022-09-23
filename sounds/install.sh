#!/bin/bash


CINN_VERSION=$(cinnamon --version)
CWD=$(pwd)
LWD=$HOME/.local/share/sounds && mkdir -p $LWD
UWD=/usr/share/sounds


set_sound () {
    SOUND_THEME=$UWD/harmony/index.theme
    
    # READ THE CONFIG
    SOUND_FILE=$(awk -F '=' '/^\s*'${1}'\s*=/ {
        sub(/^ +/, "", $2);
        sub(/ +$/, "", $2);
        print $2;
        exit;
    }' $SOUND_THEME)
    
    SOUND_SET=$(echo $SOUND_FILE | tr -d \'\" )
    gsettings set org.cinnamon.sounds $1 $UWD/$SOUND_SET
}

set_sound "tile-file"
set_sound "plug-file"
set_sound "unplug-file"
set_sound "close-file"
set_sound "map-file"
set_sound "minimize-file"
set_sound "logout-file"
set_sound "maximize-file"
set_sound "switch-file"
set_sound "notification-file"
set_sound "unmaximize-file"
set_sound "login-file"
#set_sound "volume-sound-file"


exit

echo "[i] Before running the install note the changes documented such as needing to backup your /usr/share/sounds/ directory."
read -p "[Q] Do you wish to continue (y/n)? " answer
case ${answer:0:1} in
    y|Y )
        echo ""
        echo "[i] - Backing up your Cinnamon settings"
        dconf dump /org/cinnamon/ > $CWD/cinnamon_desktop.backup
        
        gsettings set org.cinnamon.sounds notification-enabled "true"
        
        # UPDATE FROM GIT
        if [ -d ../.git ] ; then
            echo "[i] - Updating from GitHub"
            cd ../
            git fetch
            git pull
            cd $CWD
        fi
        
        echo "[i] - Copying sounds to /usr/share/sounds (reason for needing sudo)"
        # REMOVE AND REINSTALL SOUNDS
        # SOUND - ZORIN
        if [ -d $UWD/zorin ] ; then
            sudo rm -rf $UWD/zorin
        fi

        sudo cp -fr $CWD/zorin/ $UWD
        sudo chmod -R a+rx $UWD/zorin

        # SOUND - X11
        if [ -d $UWD/x11 ] ; then
            sudo rm -rf $UWD/x11
        fi

        sudo cp -fr $CWD/x11/ $UWD
        sudo chmod -R a+rx $UWD/x11

        # SOUND - X10
        if [ -d $UWD/x10 ] ; then
            sudo rm -rf $UWD/x10
        fi

        sudo cp -fr $CWD/x10 $UWD
        sudo chmod -R a+rx $UWD/x10

        # SOUND - X10 CRYSTAL
        if [ -d $UWD/x10-crystal ] ; then
            sudo rm -rf $UWD/x10-crystal
        fi

        sudo cp -fr $CWD/x10-crystal $UWD
        sudo chmod -R a+rx $UWD/x10-crystal

        # SOUND - XXP
        if [ -d $UWD/xxp ] ; then
            sudo rm -rf $UWD/xxp
        fi

        sudo cp -fr $CWD/xxp $UWD
        sudo chmod -R a+rx $UWD/xxp

        # SOUND - MIUI
        if [ -d $UWD/miui ] ; then
            sudo rm -rf $UWD/miui
        fi

        sudo cp -fr $CWD/miui $UWD
        sudo chmod -R a+rx $UWD/miui

        # SOUND - DEEPIN
        if [ -d $UWD/deepin ] ; then
            sudo rm -rf $UWD/deepin
        fi

        sudo cp -fr $CWD/deepin $UWD
        sudo chmod -R a+rx $UWD/deepin

        # SOUND - IOS Remix
        if [ -d $UWD/ios-remix ] ; then
            sudo rm -rf $UWD/ios-remix
        fi

        sudo cp -fr $CWD/ios-remix $UWD
        sudo chmod -R a+rx $UWD/ios-remix

        # SOUND - BOREALIS
        if [ -d $UWD/borealis ] ; then
            sudo rm -rf $UWD/borealis
        fi

        sudo cp -fr $CWD/borealis $UWD
        sudo chmod -R a+rx $UWD/borealis

        # SOUND - HARMONY
        if [ -d $UWD/harmony ] ; then
            sudo rm -rf $UWD/harmony
        fi

        sudo cp -fr $CWD/harmony $UWD
        sudo chmod -R a+rx $UWD/harmony

        # SOUND - DREAM
        if [ -d $UWD/dream ] ; then
            sudo rm -rf $UWD/dream
        fi
        
        sudo cp -fr $CWD/dream $UWD
        sudo chmod -R a+rx $UWD/dream
        
        # SOUND - HYDROGEN
        if [ -d $UWD/hydrogen ] ; then
            sudo rm -rf $UWD/hydrogen
        fi

        sudo cp -fr $CWD/hydrogen $UWD
        sudo chmod -R a+rx $UWD/hydrogen

        # SOUND - LINUX-A11Y
        if [ -d $UWD/linux-a11y ] ; then
            sudo rm -rf $UWD/linux-a11y
        fi

        sudo cp -fr $CWD/linux-a11y/ $UWD
        sudo chmod -R a+rx $UWD/linux-a11y

        # SOUND - SAMSUNG-RETRO
        if [ -d $UWD/samsung-retro ] ; then
            sudo rm -rf $UWD/samsung-retro
        fi

        sudo cp -fr $CWD/samsung-retro $UWD
        sudo chmod -R a+rx $UWD/samsung-retro

        # SOUND - TEAM PIXEL
        if [ -d $UWD/teampixel ] ; then
            sudo rm -rf $UWD/teampixel
        fi

        sudo cp -fr $CWD/teampixel/ $UWD
        sudo chmod -R a+rx $UWD/teampixel
        
        
        
        
        # INSTALL NEW DEFAULT IF ON CINNAMON
        if awk "BEGIN {exit !($CINN_VERSION > 1)}"; then
            echo "[i] Setting default sounds for Cinnamon"
            # SOUND - FRESH DREAM
            gsettings set org.cinnamon.sounds tile-file '/usr/share/sounds/dream/stereo/window-close.ogg'
            gsettings set org.cinnamon.sounds plug-file '/usr/share/sounds/dream/stereo/device-added.ogg'
            gsettings set org.cinnamon.sounds unplug-file '/usr/share/sounds/dream/stereo/device-removed.ogg'
            gsettings set org.cinnamon.sounds close-file '/usr/share/sounds/dream/stereo/window-close.ogg'
            gsettings set org.cinnamon.sounds map-file '/usr/share/sounds/dream/stereo/window-close.ogg'
            gsettings set org.cinnamon.sounds minimize-file '/usr/share/sounds/dream/stereo/window-close.ogg'
            gsettings set org.cinnamon.sounds logout-file '/usr/share/sounds/dream/stereo/desktop-logout.ogg'
            gsettings set org.cinnamon.sounds maximize-file '/usr/share/sounds/dream/stereo/window-close.ogg'
            gsettings set org.cinnamon.sounds switch-file '/usr/share/sounds/dream/stereo/window-slide.ogg'
            gsettings set org.cinnamon.sounds notification-file '/usr/share/sounds/dream/stereo/dialog-question.ogg'
            gsettings set org.cinnamon.sounds unmaximize-file '/usr/share/sounds/dream/stereo/window-close.ogg'
            gsettings set org.cinnamon.sounds login-file '/usr/share/sounds/dream/stereo/desktop-login.ogg'
            gsettings set org.cinnamon.desktop.sound volume-sound-file '/usr/share/sounds/dream/stereo/audio-volume-change.ogg' 
        fi
           
        
    ;;
    * )
        exit
    ;;
esac