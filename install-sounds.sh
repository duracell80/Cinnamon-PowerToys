#!/bin/bash


CINN_VERSION=$(cinnamon --version)
CWD=$(pwd)
LWD=$HOME/.local/share/sounds && mkdir -p $LWD
UWD=/usr/share/sounds
DIR_SOUND=$UWD

SOUND_THEME="linux-mint-21"


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
chmod u+x $HOME/.local/bin/set_sound_theme


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

	# SOUND - MINT 21
        if [ -d $UWD/linux-mint-21 ] ; then
            sudo rm -rf $UWD/linux-mint-21
        fi

        sudo cp -fr $CWD/sounds/linux-mint-21/ $UWD
        sudo chmod -R a+rx $UWD/linux-mint-21

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

PS3='Choose a sound theme to apply: '
names=("none" "borealis" "deepin" "dream" "harmony" "hydrogen" "ios-remix" "linux-a11y" "linux-mint-21" "miui" "samsung-retro" "teampixel" "x10" "x10-crystal" "x11" "xxp" "zorin")
select wall in "${names[@]}"; do
    case $wall in
        "borealis")
            $HOME/.local/bin/set_sound_theme borealis
            break
            ;;
        "deepin")
            $HOME/.local/bin/set_sound_theme deepin
            break
            ;;
	"dream")
            $HOME/.local/bin/set_sound_theme dream
            break
            ;;
	"harmony")
            $HOME/.local/bin/set_sound_theme harmony
            break
            ;;
	"hydrogen")
            $HOME/.local/bin/set_sound_theme hydrogen
            break
            ;;
	"ios-remix")
            $HOME/.local/bin/set_sound_theme ios-remix
            break
            ;;
	"linux-a11y")
            $HOME/.local/bin/set_sound_theme linux-a11y
            break
            ;;
	"linux-mint-21")
            $HOME/.local/bin/set_sound_theme linux-mint-21
            break
            ;;
	"miui")
            $HOME/.local/bin/set_sound_theme miui
            break
            ;;
	"samsung-retro")
            $HOME/.local/bin/set_sound_theme samsung-retro
            break
            ;;
	"teampixel")
            $HOME/.local/bin/set_sound_theme teampixel
            break
            ;;
	"x10")
            $HOME/.local/bin/set_sound_theme x10
            break
            ;;
	"x11")
            $HOME/.local/bin/set_sound_theme x11
            break
            ;;
	"xxp")
            $HOME/.local/bin/set_sound_theme xxp
            break
            ;;
	"zorin")
            $HOME/.local/bin/set_sound_theme zorin
            break
            ;;
	"none")
            echo "[i] No sound theme selected and no changes made"
            break
            ;;
        *) echo "[!] Invalid sound theme";;
    esac
done


PS3='Choose a custom notification sound to apply: '
names=("as themed" "linux-a11y" "teampixel" "pixel-keys" "pixel-flourish" "pixel-flutter" "pixel-carbonate" "pixel-discovery" "pixel-epiphany" "pixel-everblur" "pixel-gradient" "pixel-lota" "pixel-moondrop" "pixel-plonk" "pixel-scamper" "pixel-shuffle" "pixel-sunflower" "pixel-teapot" "pixel-birdsong" "pixel-absurdbird" "chefsspecial" "pixel-crosswalk" "pixel-cyclist" "pixel-dj" "pixel-doorbell" "pixel-grandopening" "pixel-honkhonk" "pixel-nightlife" "pixel-nightsky" "pixel-rockconcert" "pixel-welcome" "pixel-bikeride" "pixel-blacksmith" "pixel-cowbell" "pixel-cointoss" "pixel-fraidycat" "pixel-gibboncall" "pixel-guardianangel" "pixel-magictrick" "pixel-paperclip" "pixel-pingpong" "pixel-sadtrombone" "pixel-swansong" "pixel-tropicalfrog" "pixel-bolt" "pixel-boomerang" "pixel-bubble" "pixel-coins" "pixel-gems" "pixel-jackpot" "pixel-magic" "pixel-portal" "pixel-reward" "pixel-spell" "pixel-unlock" "pixel-bemine" "pixel-champagnepop" "pixel-cheers" "pixel-eerie" "pixel-gobblegobble" "pixel-holidaymagic" "pixel-partyfavor" "pixel-sleighbells" "pixel-snowflake" "pixel-summersurf" "pixel-sweatheart" "pixel-winterwind" "pixel-chime" "pixel-clink" "pixel-flick" "pixel-hey" "pixel-note" "pixel-strum" "pixel-trill" "x11" "x10" "x10-crystal" "xxp" "miui" "deepin" "borealis" "hydrogen" "dream" "zorin" "samsung-retro" "ios-remix")
select name in "${names[@]}"; do
    case $name in
        "teampixel")
		APP_SOUND="$DIR_SOUND/teampixel/notification_simple-01.ogg"
            break
            ;;
        "linux-a11y")
            	APP_SOUND="$DIR_SOUND/linux-a11y/stereo/window-attention.ogg"
            break
            ;;
	"as themed")
            echo "[i] No notification sound changes made"
		APP_SOUND="none"
	    break
            ;;
        *) echo "[!] Invalid sound selection";;
    esac
done


# SET CUSTOM NOTIFICATION SOUND
if [[ "$APP_SOUND" -ne "none" ]];then
	gsettings set org.cinnamon.sounds notification-file "$APP_SOUND"
fi


    if [ "$name" == "linux-a11y" ]; then
        APP_SOUND="$DIR_SOUND/linux-a11y/stereo/window-attention.ogg"
    elif [ "$name" == "teampixel" ]; then
        APP_SOUND="$DIR_SOUND/teampixel/notification_simple-01.ogg"
    elif [ "$name" == "pixel-keys" ]; then
        APP_SOUND="$DIR_SOUND/teampixel/notifications/Classical Harmonies/Changing Keys.ogg"
    elif [ "$name" == "pixel-flourish" ]; then
        APP_SOUND="$DIR_SOUND/teampixel/notifications/Classical Harmonies/Piano Flourish.ogg"
    elif [ "$name" == "pixel-flutter" ]; then
        APP_SOUND="$DIR_SOUND/teampixel/notifications/Classical Harmonies/Piano Flutter.ogg"
    elif [ "$name" == "pixel-carbonate" ]; then
        APP_SOUND="$DIR_SOUND/teampixel/notifications/Material Adventures/Carbonate.ogg"
    elif [ "$name" == "pixel-discovery" ]; then
        APP_SOUND="$DIR_SOUND/teampixel/notifications/Material Adventures/Discovery.ogg"
    elif [ "$name" == "pixel-epiphany" ]; then
        APP_SOUND="$DIR_SOUND/teampixel/notifications/Material Adventures/Epiphany.ogg"
    elif [ "$name" == "pixel-everblue" ]; then
        APP_SOUND="$DIR_SOUND/teampixel/notifications/Material Adventures/Everblue.ogg"
    elif [ "$name" == "pixel-gradient" ]; then
        APP_SOUND="$DIR_SOUND/teampixel/notifications/Material Adventures/Gradient.ogg"
    elif [ "$name" == "pixel-lota" ]; then
        APP_SOUND="$DIR_SOUND/teampixel/notifications/Material Adventures/Lota.ogg"
    elif [ "$name" == "pixel-moondrop" ]; then
        APP_SOUND="$DIR_SOUND/teampixel/notifications/Material Adventures/Moondrop.ogg"
    elif [ "$name" == "pixel-plonk" ]; then
        APP_SOUND="$DIR_SOUND/teampixel/notifications/Material Adventures/Plonk.ogg"
    elif [ "$name" == "pixel-scamper" ]; then
        APP_SOUND="$DIR_SOUND/teampixel/notifications/Material Adventures/Scamper.ogg"
    elif [ "$name" == "pixel-shuffle" ]; then
        APP_SOUND="$DIR_SOUND/teampixel/notifications/Material Adventures/Shuffle.ogg"
    elif [ "$name" == "pixel-sunflower" ]; then
        APP_SOUND="$DIR_SOUND/teampixel/notifications/Material Adventures/Sunflower.ogg"
    elif [ "$name" == "pixel-teapot" ]; then
        APP_SOUND="$DIR_SOUND/teampixel/notifications/Material Adventures/Teapot.ogg"
    elif [ "$name" == "pixel-birdsong" ]; then
        APP_SOUND="$DIR_SOUND/teampixel/notifications/Pixel Sounds/Birdsong.ogg"
    elif [ "$name" == "pixel-absurdbird" ]; then
        APP_SOUND="$DIR_SOUND/teampixel/notifications/Play It Loud/Absurd Bird.ogg"
    elif [ "$name" == "pixel-chefsspecial" ]; then
        APP_SOUND="$DIR_SOUND/teampixel/notifications/Play It Loud/Chef_s Special.ogg"
    elif [ "$name" == "pixel-crosswalk" ]; then
        APP_SOUND="$DIR_SOUND/teampixel/notifications/Play It Loud/Crosswalk.ogg"
    elif [ "$name" == "pixel-cyclist" ]; then
        APP_SOUND="$DIR_SOUND/teampixel/notifications/Play It Loud/Cyclist.ogg"
    elif [ "$name" == "pixel-dj" ]; then
        APP_SOUND="$DIR_SOUND/teampixel/notifications/Play It Loud/DJ.ogg"
    elif [ "$name" == "pixel-doorbell" ]; then
        APP_SOUND="$DIR_SOUND/teampixel/notifications/Play It Loud/Doorbell.ogg"
    elif [ "$name" == "pixel-grandopening" ]; then
        APP_SOUND="$DIR_SOUND/teampixel/notifications/Play It Loud/Grand Opening.ogg"
    elif [ "$name" == "pixel-honkhonk" ]; then
        APP_SOUND="$DIR_SOUND/teampixel/notifications/Play It Loud/Honk Honk.ogg"
    elif [ "$name" == "pixel-nightlife" ]; then
        APP_SOUND="$DIR_SOUND/teampixel/notifications/Play It Loud/Nightlife.ogg"
    elif [ "$name" == "pixel-nightsky" ]; then
        APP_SOUND="$DIR_SOUND/teampixel/notifications/Play It Loud/Night Sky.ogg"
    elif [ "$name" == "pixel-rockconcert" ]; then
        APP_SOUND="$DIR_SOUND/teampixel/notifications/Play It Loud/Rock Concert.ogg"
    elif [ "$name" == "pixel-welcome" ]; then
        APP_SOUND="$DIR_SOUND/teampixel/notifications/Play It Loud/Welcome.ogg"
    elif [ "$name" == "pixel-bellhop" ]; then
        APP_SOUND="$DIR_SOUND/teampixel/notifications/Reality Bytes/Bellhop.ogg"
    elif [ "$name" == "pixel-bikeride" ]; then
        APP_SOUND="$DIR_SOUND/teampixel/notifications/Reality Bytes/Bike Ride.ogg"
    elif [ "$name" == "pixel-blacksmith" ]; then
        APP_SOUND="$DIR_SOUND/teampixel/notifications/Reality Bytes/Blacksmith.ogg"
    elif [ "$name" == "pixel-cowbell" ]; then
        APP_SOUND="$DIR_SOUND/teampixel/notifications/Reality Bytes/Cowbell.ogg"
    elif [ "$name" == "pixel-cointoss" ]; then
        APP_SOUND="$DIR_SOUND/teampixel/notifications/Reality Bytes/Coin Toss.ogg"
    elif [ "$name" == "pixel-fraidycat" ]; then
        APP_SOUND="$DIR_SOUND/teampixel/notifications/Reality Bytes/Fraidy Cat.ogg"
    elif [ "$name" == "pixel-gibboncall" ]; then
        APP_SOUND="$DIR_SOUND/teampixel/notifications/Reality Bytes/Gibbon Call.ogg"
    elif [ "$name" == "pixel-guardianangel" ]; then
        APP_SOUND="$DIR_SOUND/teampixel/notifications/Reality Bytes/Guardian Angel.ogg"
    elif [ "$name" == "pixel-magictrick" ]; then
        APP_SOUND="$DIR_SOUND/teampixel/notifications/Reality Bytes/Magic Trick.ogg"
    elif [ "$name" == "pixel-paperclip" ]; then
        APP_SOUND="$DIR_SOUND/teampixel/notifications/Reality Bytes/Paper Clip.ogg"
    elif [ "$name" == "pixel-pingpong" ]; then
        APP_SOUND="$DIR_SOUND/teampixel/notifications/Reality Bytes/Ping-Pong.ogg"
    elif [ "$name" == "pixel-sadtrombone" ]; then
        APP_SOUND="$DIR_SOUND/teampixel/notifications/Reality Bytes/Sad Trombone.ogg"
    elif [ "$name" == "pixel-swansong" ]; then
        APP_SOUND="$DIR_SOUND/teampixel/notifications/Reality Bytes/Swan Song.ogg"
    elif [ "$name" == "pixel-tropicalfrog" ]; then
        APP_SOUND="$DIR_SOUND/teampixel/notifications/Reality Bytes/Tropical Frog.ogg"
    elif [ "$name" == "pixel-welcome" ]; then
        APP_SOUND="$DIR_SOUND/teampixel/notifications/Reality Bytes/Welcome.ogg"
    elif [ "$name" == "pixel-bolt" ]; then
        APP_SOUND="$DIR_SOUND/teampixel/notifications/Retro Riffs/Bolt.ogg"
    elif [ "$name" == "pixel-boomerang" ]; then
        APP_SOUND="$DIR_SOUND/teampixel/notifications/Retro Riffs/Boomerang.ogg"
    elif [ "$name" == "pixel-bubble" ]; then
        APP_SOUND="$DIR_SOUND/teampixel/notifications/Retro Riffs/Bubble.ogg"
    elif [ "$name" == "pixel-coins" ]; then
        APP_SOUND="$DIR_SOUND/teampixel/notifications/Retro Riffs/Coins.ogg"
    elif [ "$name" == "pixel-gems" ]; then
        APP_SOUND="$DIR_SOUND/teampixel/notifications/Retro Riffs/Gems.ogg"
    elif [ "$name" == "pixel-jackpot" ]; then
        APP_SOUND="$DIR_SOUND/teampixel/notifications/Retro Riffs/Jackpot.ogg"
    elif [ "$name" == "pixel-magic" ]; then
        APP_SOUND="$DIR_SOUND/teampixel/notifications/Retro Riffs/Magic.ogg"
    elif [ "$name" == "pixel-portal" ]; then
        APP_SOUND="$DIR_SOUND/teampixel/notifications/Retro Riffs/Portal.ogg"
    elif [ "$name" == "pixel-reward" ]; then
        APP_SOUND="$DIR_SOUND/teampixel/notifications/Retro Riffs/Reward.ogg"
    elif [ "$name" == "pixel-spell" ]; then
        APP_SOUND="$DIR_SOUND/teampixel/notifications/Retro Riffs/Spell.ogg"
    elif [ "$name" == "pixel-unlock" ]; then
        APP_SOUND="$DIR_SOUND/teampixel/notifications/Retro Riffs/Unlock.ogg"
    elif [ "$name" == "pixel-bemine" ]; then
    	APP_SOUND="$DIR_SOUND/teampixel/notifications/Seasonal Celebrations/Be Mine.ogg"
    elif [ "$name" == "pixel-champagnepop" ]; then
        APP_SOUND="$DIR_SOUND/teampixel/notifications/Seasonal Celebrations/Champagne Pop.ogg"
    elif [ "$name" == "pixel-cheers" ]; then
        APP_SOUND="$DIR_SOUND/teampixel/notifications/Seasonal Celebrations/Cheers.ogg"
    elif [ "$name" == "pixel-eerie" ]; then
        APP_SOUND="$DIR_SOUND/teampixel/notifications/Seasonal Celebrations/Eerie.ogg"
    elif [ "$name" == "pixel-gobblegobble" ]; then
        APP_SOUND="$DIR_SOUND/teampixel/notifications/Seasonal Celebrations/Gobble Gobble.ogg"
    elif [ "$name" == "pixel-holidaymagic" ]; then
        APP_SOUND="$DIR_SOUND/teampixel/notifications/Seasonal Celebrations/Holiday Magic.ogg"
    elif [ "$name" == "pixel-partyfavor" ]; then
        APP_SOUND="$DIR_SOUND/teampixel/notifications/Seasonal Celebrations/Party Favor.ogg"
    elif [ "$name" == "pixel-sleighbells" ]; then
        APP_SOUND="$DIR_SOUND/teampixel/notifications/Seasonal Celebrations/Sleigh Bells.ogg"
    elif [ "$name" == "pixel-snowflake" ]; then
        APP_SOUND="$DIR_SOUND/teampixel/notifications/Seasonal Celebrations/Snowflake.ogg"
    elif [ "$name" == "pixel-summersurf" ]; then
        APP_SOUND="$DIR_SOUND/teampixel/notifications/Seasonal Celebrations/Summer Surf.ogg"
    elif [ "$name" == "pixel-sweatheart" ]; then
        APP_SOUND="$DIR_SOUND/teampixel/notifications/Seasonal Celebrations/Sweetheart.ogg"
    elif [ "$name" == "pixel-winterwind" ]; then
        APP_SOUND="$DIR_SOUND/teampixel/notifications/Seasonal Celebrations/Winter Wind.ogg"
    elif [ "$name" == "pixel-chime" ]; then
        APP_SOUND="$DIR_SOUND/teampixel/notifications/Pixel Sounds/Chime.ogg"
    elif [ "$name" == "pixel-clink" ]; then
        APP_SOUND="$DIR_SOUND/teampixel/notifications/Pixel Sounds/Clink.ogg"
    elif [ "$name" == "pixel-flick" ]; then
        APP_SOUND="$DIR_SOUND/teampixel/notifications/Pixel Sounds/Flick.ogg"
    elif [ "$name" == "pixel-hey" ]; then
        APP_SOUND="$DIR_SOUND/teampixel/notifications/Pixel Sounds/Hey.ogg"
    elif [ "$name" == "pixel-note" ]; then
        APP_SOUND="$DIR_SOUND/teampixel/notifications/Pixel Sounds/Note.ogg"
    elif [ "$name" == "pixel-strum" ]; then
        APP_SOUND="$DIR_SOUND/teampixel/notifications/Pixel Sounds/Strum.ogg"
    elif [ "$name" == "pixel-trill" ]; then
        APP_SOUND="$DIR_SOUND/teampixel/notifications/Pixel Sounds/Trill.ogg"
    elif [ "$name" == "x11" ]; then
        APP_SOUND="$DIR_SOUND/x11/stereo/message-new-instant.ogg"
    elif [ "$name" == "x10" ]; then
        APP_SOUND="$DIR_SOUND/x10/stereo/window-attention-inactive.ogg"
    elif [ "$name" == "x10-crystal" ]; then
        APP_SOUND="$DIR_SOUND/x10-crystal/stereo/message-new-instant.ogg"
    elif [ "$name" == "xxp" ]; then
        APP_SOUND="$DIR_SOUND/xxp/stereo/message-new-instant.ogg"
    elif [ "$name" == "miui" ]; then
        APP_SOUND="$DIR_SOUND/miui/stereo/message-sent-instant.ogg"
    elif [ "$name" == "deepin" ]; then
        APP_SOUND="$DIR_SOUND/deepin/stereo/message.ogg"
    elif [ "$name" == "borealis" ]; then
        APP_SOUND="$DIR_SOUND/borealis/stereo/message-new-instant-alt.ogg"
    elif [ "$name" == "harmony" ]; then
        APP_SOUND="$DIR_SOUND/harmony/stereo/message-new-instant.ogg"
    elif [ "$name" == "hydrogen" ]; then
        APP_SOUND="$DIR_SOUND/hydrogen/stereo/message-new-email.ogg"
    elif [ "$name" == "dream" ]; then
        APP_SOUND="$DIR_SOUND/dream/stereo/battery-full.ogg"
    elif [ "$name" == "zorin" ]; then
        APP_SOUND="$DIR_SOUND/zorin/stereo/success.ogg"
    elif [ "$name" == "samsung-retro" ]; then
        APP_SOUND="$DIR_SOUND/samsung-retro/stereo/message-new-email.ogg"
    elif [ "$name" == "ios-remix" ]; then
        APP_SOUND="$DIR_SOUND/ios-remix/stereo/message-new-instant.ogg"
    fi
    # APPLY THE NOTIFICATION AS CUSTOMIZED
    #gsettings set org.cinnamon.sounds notification-file "$APP_SOUND"
