#!/bin/bash


CINN_VERSION=$(cinnamon --version)
CWD=$(pwd)
LWD=$HOME/.local/share/sounds && mkdir -p $LWD
UWD=/usr/share/sounds

SOUND_THEME="dream"


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

cp -f $CWD/sounds/scripts/set_sound_theme.sh $HOME/.local/bin/set_sound_theme

echo "[i] Before running the install note the changes documented such as needing to backup your /usr/share/sounds/ directory."
read -p "[Q] Do you wish to continue (y/n)? " answer
case ${answer:0:1} in
    y|Y )
        echo ""
        echo "[i] - Backing up your Cinnamon settings"
        dconf dump /org/cinnamon/ > $CWD/sounds/scripts/cinnamon_desktop.backup
        
        gsettings set org.cinnamon.sounds notification-enabled "true"
        
        # UPDATE FROM GIT
        if [ -d ../.git ] ; then
            echo "[i] - Updating from GitHub"
            cd ../
            git fetch
            git pull
            cd $CWD
        fi
        
        echo "[i] - Copying sound themes with enhanced index.theme files to /usr/share/sounds (reason for needing sudo)"
        # REMOVE AND REINSTALL SOUNDS
        # SOUND - ZORIN
        if [ -d $UWD/zorin ] ; then
            sudo rm -rf $UWD/zorin
        fi

        sudo cp -fr $CWD/sounds/zorin/ $UWD
        sudo chmod -R a+rx $UWD/zorin

        # SOUND - X11
        if [ -d $UWD/x11 ] ; then
            sudo rm -rf $UWD/x11
        fi

        sudo cp -fr $CWD/sounds/x11/ $UWD
        sudo chmod -R a+rx $UWD/x11

        # SOUND - X10
        if [ -d $UWD/x10 ] ; then
            sudo rm -rf $UWD/x10
        fi

        sudo cp -fr $CWD/sounds/x10 $UWD
        sudo chmod -R a+rx $UWD/x10

        # SOUND - X10 CRYSTAL
        if [ -d $UWD/x10-crystal ] ; then
            sudo rm -rf $UWD/x10-crystal
        fi

        sudo cp -fr $CWD/sounds/x10-crystal $UWD
        sudo chmod -R a+rx $UWD/x10-crystal

        # SOUND - XXP
        if [ -d $UWD/xxp ] ; then
            sudo rm -rf $UWD/xxp
        fi

        sudo cp -fr $CWD/sounds/xxp $UWD
        sudo chmod -R a+rx $UWD/xxp

        # SOUND - MIUI
        if [ -d $UWD/miui ] ; then
            sudo rm -rf $UWD/miui
        fi

        sudo cp -fr $CWD/sounds/miui $UWD
        sudo chmod -R a+rx $UWD/miui

        # SOUND - DEEPIN
        if [ -d $UWD/deepin ] ; then
            sudo rm -rf $UWD/deepin
        fi

        sudo cp -fr $CWD/sounds/deepin $UWD
        sudo chmod -R a+rx $UWD/deepin

        # SOUND - IOS Remix
        if [ -d $UWD/ios-remix ] ; then
            sudo rm -rf $UWD/ios-remix
        fi

        sudo cp -fr $CWD/sounds/ios-remix $UWD
        sudo chmod -R a+rx $UWD/ios-remix

        # SOUND - BOREALIS
        if [ -d $UWD/sounds/borealis ] ; then
            sudo rm -rf $UWD/borealis
        fi

        sudo cp -fr $CWD/sounds/borealis $UWD
        sudo chmod -R a+rx $UWD/borealis

        # SOUND - HARMONY
        if [ -d $UWD/harmony ] ; then
            sudo rm -rf $UWD/harmony
        fi

        sudo cp -fr $CWD/sounds/harmony $UWD
        sudo chmod -R a+rx $UWD/harmony

        # SOUND - DREAM
        if [ -d $UWD/dream ] ; then
            sudo rm -rf $UWD/dream
        fi
        
        sudo cp -fr $CWD/sounds/dream $UWD
        sudo chmod -R a+rx $UWD/dream
        
        # SOUND - HYDROGEN
        if [ -d $UWD/hydrogen ] ; then
            sudo rm -rf $UWD/hydrogen
        fi

        sudo cp -fr $CWD/sounds/hydrogen $UWD
        sudo chmod -R a+rx $UWD/hydrogen

        # SOUND - LINUX-A11Y
        if [ -d $UWD/linux-a11y ] ; then
            sudo rm -rf $UWD/linux-a11y
        fi

        sudo cp -fr $CWD/sounds/linux-a11y/ $UWD
        sudo chmod -R a+rx $UWD/linux-a11y

        # SOUND - SAMSUNG-RETRO
        if [ -d $UWD/samsung-retro ] ; then
            sudo rm -rf $UWD/samsung-retro
        fi

        sudo cp -fr $CWD/sounds/samsung-retro $UWD
        sudo chmod -R a+rx $UWD/samsung-retro

        # SOUND - TEAM PIXEL
        if [ -d $UWD/teampixel ] ; then
            sudo rm -rf $UWD/teampixel
        fi

        sudo cp -fr $CWD/sounds/teampixel/ $UWD
        sudo chmod -R a+rx $UWD/teampixel
        
        
        
        
        # INSTALL NEW DEFAULT IF ON CINNAMON
        if awk "BEGIN {exit !($CINN_VERSION > 1)}"; then
            echo "[i] - Setting default sounds for Cinnamon"
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
           
        
    ;;
    * )
        exit
    ;;
esac