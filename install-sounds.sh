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
	    gsettings set x.dm.slick-greeter play-ready-sound '/usr/share/sounds/borealis/stereo/system-ready.ogg'
            break
            ;;
        "deepin")
            $HOME/.local/bin/set_sound_theme deepin
	    gsettings set x.dm.slick-greeter play-ready-sound '/usr/share/sounds/deepin/stereo/message.ogg'
            break
            ;;
	"dream")
            $HOME/.local/bin/set_sound_theme dream
	    gsettings set x.dm.slick-greeter play-ready-sound '/usr/share/sounds/dream/stereo/system-bootup.ogg'
            break
            ;;
	"harmony")
            $HOME/.local/bin/set_sound_theme harmony
	    gsettings set x.dm.slick-greeter play-ready-sound '/usr/share/sounds/harmony/stereo/system-ready.ogg'
            break
            ;;
	"hydrogen")
            $HOME/.local/bin/set_sound_theme hydrogen
	    gsettings set x.dm.slick-greeter play-ready-sound '/usr/share/sounds/hydrogen/stereo/system-ready.ogg'
            break
            ;;
	"ios-remix")
            $HOME/.local/bin/set_sound_theme ios-remix
	    gsettings set x.dm.slick-greeter play-ready-sound '/usr/share/sounds/ios-remix/stereo/desktop-login-modern.ogg'
            break
            ;;
	"linux-a11y")
            $HOME/.local/bin/set_sound_theme linux-a11y
	    gsettings set x.dm.slick-greeter play-ready-sound '/usr/share/sounds/linux-a11y/stereo/system-ready.ogg'
            break
            ;;
	"linux-mint-21")
            $HOME/.local/bin/set_sound_theme linux-mint-21
	    gsettings set x.dm.slick-greeter play-ready-sound '/usr/share/sounds/linux-mint-21/stereo/system-ready.ogg'
            break
            ;;
	"miui")
            $HOME/.local/bin/set_sound_theme miui
	    gsettings set x.dm.slick-greeter play-ready-sound '/usr/share/sounds/miui/stereo/system-ready.ogg'
            break
            ;;
	"samsung-retro")
            $HOME/.local/bin/set_sound_theme samsung-retro
	    gsettings set x.dm.slick-greeter play-ready-sound '/usr/share/sounds/samsung-retro/stereo/system-ready.ogg'
            break
            ;;
	"teampixel")
            $HOME/.local/bin/set_sound_theme teampixel
	    gsettings set x.dm.slick-greeter play-ready-sound '/usr/share/sounds/teampixel/notification_ambient.ogg'
            break
            ;;
	"x10")
            $HOME/.local/bin/set_sound_theme x10
	    gsettings set x.dm.slick-greeter play-ready-sound '/usr/share/sounds/x10/stereo/system-ready.ogg'
            break
            ;;
	"x10-crystal")
            $HOME/.local/bin/set_sound_theme x10-crystal
            gsettings set x.dm.slick-greeter play-ready-sound '/usr/share/sounds/x10-crystal/stereo/system-bootup.ogg'
            break
            ;;
	"x11")
            $HOME/.local/bin/set_sound_theme x11
	    gsettings set x.dm.slick-greeter play-ready-sound '/usr/share/sounds/x11/stereo/system-ready.ogg'
            break
            ;;
	"xxp")
            $HOME/.local/bin/set_sound_theme xxp
            gsettings set x.dm.slick-greeter play-ready-sound '/usr/share/sounds/xxp/stereo/system-bootup.ogg'
            break
            ;;
	"zorin")
            $HOME/.local/bin/set_sound_theme zorin
            gsettings set x.dm.slick-greeter play-ready-sound '/usr/share/sounds/zorin/stereo/message-new-instant.ogg'
            break
            ;;
	"none")
            echo "[i] No sound theme selected and no changes made"
            break
            ;;
        *) echo "[!] Invalid sound theme";;
    esac
done

choose_notif () {
    PS3='Choose a custom notification sound to apply: '
    names=("as themed" "linux-a11y" "teampixel" "pixel-keys" "pixel-flourish" "pixel-flutter" "pixel-carbonate" "pixel-discovery" "pixel-epiphany" "pixel-everblue" "pixel-gradient" "pixel-lota" "pixel-moondrop" "pixel-plonk" "pixel-scamper" "pixel-shuffle" "pixel-sunflower" "pixel-teapot" "pixel-birdsong" "pixel-absurdbird" "chefsspecial" "pixel-crosswalk" "pixel-cyclist" "pixel-dj" "pixel-doorbell" "pixel-grandopening" "pixel-honkhonk" "pixel-nightlife" "pixel-nightsky" "pixel-rockconcert" "pixel-welcome" "pixel-welcome2" "pixel-bikeride" "pixel-blacksmith" "pixel-cowbell" "pixel-cointoss" "pixel-fraidycat" "pixel-gibboncall" "pixel-guardianangel" "pixel-magictrick" "pixel-paperclip" "pixel-pingpong" "pixel-sadtrombone" "pixel-swansong" "pixel-tropicalfrog" "pixel-bolt" "pixel-boomerang" "pixel-bubble" "pixel-coins" "pixel-gems" "pixel-jackpot" "pixel-magic" "pixel-portal" "pixel-reward" "pixel-spell" "pixel-unlock" "pixel-bemine" "pixel-champagnepop" "pixel-cheers" "pixel-eerie" "pixel-gobblegobble" "pixel-holidaymagic" "pixel-partyfavor" "pixel-sleighbells" "pixel-snowflake" "pixel-summersurf" "pixel-sweatheart" "pixel-winterwind" "pixel-chime" "pixel-clink" "pixel-flick" "pixel-hey" "pixel-note" "pixel-strum" "pixel-trill" "x11" "x10" "x10-crystal" "xxp" "miui" "deepin" "borealis" "hydrogen" "dream" "zorin" "samsung-retro" "ios-remix")
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
	"pixel-keys")
                APP_SOUND="$DIR_SOUND/teampixel/notifications/Classical Harmonies/Changing Keys.ogg"
            break
            ;;
	"pixel-flourish")
                APP_SOUND="$DIR_SOUND/teampixel/notifications/Classical Harmonies/Piano Flourish.ogg"
            break
            ;;
	"pixel-flutter")
                APP_SOUND="$DIR_SOUND/teampixel/notifications/Classical Harmonies/Piano Flutter.ogg"
            break
            ;;
	"pixel-carbonate")
                APP_SOUND="$DIR_SOUND/teampixel/notifications/Material Adventures/Carbonate.ogg"
            break
            ;;
	"pixel-discovery")
                APP_SOUND="$DIR_SOUND/teampixel/notifications/Material Adventures/Discovery.ogg"
            break
            ;;
	"pixel-epiphany")
                APP_SOUND="$DIR_SOUND/teampixel/notifications/Material Adventures/Epiphany.ogg"
            break
            ;;
        "pixel-everblue")
                APP_SOUND="$DIR_SOUND/teampixel/notifications/Material Adventures/Everblue.ogg"
            break
            ;;
	"pixel-gradient")
                APP_SOUND="$DIR_SOUND/teampixel/notifications/Material Adventures/Gradient.ogg"
            break
            ;;
        "pixel-lota")
                APP_SOUND="$DIR_SOUND/teampixel/notifications/Material Adventures/Lota.ogg"
            break
            ;;
        "pixel-moondrop")
                APP_SOUND="$DIR_SOUND/teampixel/notifications/Material Adventures/Moondrop.ogg"
            break
            ;;
        "pixel-plonk")
                APP_SOUND="$DIR_SOUND/teampixel/notifications/Material Adventures/Plonk.ogg"
            break
            ;;
	"pixel-scamper")
                APP_SOUND="$DIR_SOUND/teampixel/notifications/Material Adventures/Scamper.ogg"
            break
            ;;
        "pixel-shuffle")
                APP_SOUND="$DIR_SOUND/teampixel/notifications/Material Adventures/Shuffle.ogg"
            break
            ;;
        "pixel-sunflower")
                APP_SOUND="$DIR_SOUND/teampixel/notifications/Material Adventures/Sunflower.ogg"
            break
            ;;
        "pixel-teapot")
                APP_SOUND="$DIR_SOUND/teampixel/notifications/Material Adventures/Teapot.ogg"
            break
            ;;
	"pixel-birdsong")
                APP_SOUND="$DIR_SOUND/teampixel/notifications/Pixel Sounds/Birdsong.ogg"
            break
            ;;
	"pixel-absurdbird")
                APP_SOUND="$DIR_SOUND/teampixel/notifications/Play It Loud/Absurd Bird.ogg"
            break
            ;;
	"pixel-chefsspecial")
                APP_SOUND="$DIR_SOUND/teampixel/notifications/Play It Loud/Chef_s Special.ogg"
            break
            ;;
	"pixel-cyclist")
                APP_SOUND="$DIR_SOUND/teampixel/notifications/Play It Loud/Cyclist.ogg"
            break
            ;;
	"pixel-dj")
                APP_SOUND="$DIR_SOUND/teampixel/notifications/Play It Loud/DJ.ogg"
            break
            ;;
        "pixel-doorbell")
                APP_SOUND="$DIR_SOUND/teampixel/notifications/Play It Loud/Doorbell.ogg"
            break
            ;;
        "pixel-grandopening")
                APP_SOUND="$DIR_SOUND/teampixel/notifications/Play It Loud/Grand Opening.ogg"
            break
            ;;
	 "pixel-honkhonk")
                APP_SOUND="$DIR_SOUND/teampixel/notifications/Play It Loud/Honk Honk.ogg"
            break
            ;;
        "pixel-nightlife")
                APP_SOUND="$DIR_SOUND/teampixel/notifications/Play It Loud/Nightlife.ogg"
            break
            ;;
        "pixel-nightsky")
                APP_SOUND="$DIR_SOUND/teampixel/notifications/Play It Loud/Night Sky.ogg"
            break
            ;;
	"pixel-rockconcert")
                APP_SOUND="$DIR_SOUND/teampixel/notifications/Play It Loud/Rock Concert.ogg"
            break
            ;;
        "pixel-welcome")
                APP_SOUND="$DIR_SOUND/teampixel/notifications/Play It Loud/Welcome.ogg"
            break
            ;;
        "pixel-bellhop")
                APP_SOUND="$DIR_SOUND/teampixel/notifications/Reality Bytes/Bellhop.ogg"
            break
            ;;
	"pixel-bikeride")
                APP_SOUND="$DIR_SOUND/teampixel/notifications/Reality Bytes/Bikeride.ogg"
            break
            ;;
	"pixel-cowbell")
                APP_SOUND="$DIR_SOUND/teampixel/notifications/Reality Bytes/Cowbell.ogg"
            break
            ;;
	"pixel-cointoss")
                APP_SOUND="$DIR_SOUND/teampixel/notifications/Reality Bytes/Cointoss.ogg"
            break
            ;;
	"pixel-blacksmith")
                APP_SOUND="$DIR_SOUND/teampixel/notifications/Reality Bytes/Blacksmith.ogg"
            break
            ;;
	"pixel-fraidycat")
                APP_SOUND="$DIR_SOUND/teampixel/notifications/Reality Bytes/Fraidy Cat.ogg"
            break
            ;;
	"pixel-gibboncall")
                APP_SOUND="$DIR_SOUND/teampixel/notifications/Reality Bytes/Gibbon Call.ogg"
            break
            ;;
	"pixel-guardianangel")
                APP_SOUND="$DIR_SOUND/teampixel/notifications/Reality Bytes/Guardian Angel.ogg"
            break
            ;;
	"pixel-magictrick")
                APP_SOUND="$DIR_SOUND/teampixel/notifications/Reality Bytes/Magic Trick.ogg"
            break
            ;;
	"pixel-paperclip")
                APP_SOUND="$DIR_SOUND/teampixel/notifications/Reality Bytes/Paper Clip.ogg"
            break
            ;;
	"pixel-pingpong")
                APP_SOUND="$DIR_SOUND/teampixel/notifications/Reality Bytes/Ping-Pong.ogg"
            break
            ;;
	"pixel-sadtrombone")
                APP_SOUND="$DIR_SOUND/teampixel/notifications/Reality Bytes/Sad Trombone.ogg"
            break
            ;;
	"pixel-swansong")
                APP_SOUND="$DIR_SOUND/teampixel/notifications/Reality Bytes/Swan Song.ogg"
            break
            ;;
	"pixel-tropicalfrog")
                APP_SOUND="$DIR_SOUND/teampixel/notifications/Reality Bytes/Tropical Frog.ogg"
            break
            ;;
	"pixel-welcome2")
                APP_SOUND="$DIR_SOUND/teampixel/notifications/Reality Bytes/Welcome.ogg"
            break
            ;;
	"pixel-bolt")
                APP_SOUND="$DIR_SOUND/teampixel/notifications/Retro Riffs/Bolt.ogg"
            break
            ;;
        "pixel-boomerang")
                APP_SOUND="$DIR_SOUND/teampixel/notifications/Retro Riffs/Boomerang.ogg"
            break
            ;;
        "pixel-bubble")
                APP_SOUND="$DIR_SOUND/teampixel/notifications/Retro Riffs/Bubble.ogg"
            break
            ;;
        "pixel-coins")
                APP_SOUND="$DIR_SOUND/teampixel/notifications/Retro Riffs/Coins.ogg"
            break
            ;;
        "pixel-gems")
                APP_SOUND="$DIR_SOUND/teampixel/notifications/Retro Riffs/Gems.ogg"
            break
            ;;
        "pixel-jackpot")
                APP_SOUND="$DIR_SOUND/teampixel/notifications/Retro Riffs/Jackpot.ogg"
            break
            ;;
        "pixel-magic")
                APP_SOUND="$DIR_SOUND/teampixel/notifications/Retro Riffs/Magic.ogg"
            break
            ;;
	"pixel-portal")
                APP_SOUND="$DIR_SOUND/teampixel/notifications/Retro Riffs/Portal.ogg"
            break
            ;;
        "pixel-reward")
                APP_SOUND="$DIR_SOUND/teampixel/notifications/Retro Riffs/Reward.ogg"
            break
            ;;
        "pixel-spell")
                APP_SOUND="$DIR_SOUND/teampixel/notifications/Retro Riffs/Spell.ogg"
            break
            ;;
        "pixel-unlock")
                APP_SOUND="$DIR_SOUND/teampixel/notifications/Retro Riffs/Unlock.ogg"
            break
            ;;
	"pixel-bemine")
                APP_SOUND="$DIR_SOUND/teampixel/notifications/Seasonal Celebrations/Be Mine.ogg"
            break
            ;;
	"pixel-bemine")
                APP_SOUND="$DIR_SOUND/teampixel/notifications/Seasonal Celebrations/Be Mine.ogg"
            break
            ;;
	"pixel-champagnepop")
                APP_SOUND="$DIR_SOUND/teampixel/notifications/Seasonal Celebrations/Champagne Pop.ogg"
            break
            ;;
	"pixel-cheers")
                APP_SOUND="$DIR_SOUND/teampixel/notifications/Seasonal Celebrations/Cheers.ogg"
            break
            ;;
	"pixel-eerie")
                APP_SOUND="$DIR_SOUND/teampixel/notifications/Seasonal Celebrations/Eerie.ogg"
            break
            ;;
	"pixel-gobblegobble")
                APP_SOUND="$DIR_SOUND/teampixel/notifications/Seasonal Celebrations/Gobble Gobble.ogg"
            break
            ;;
	"pixel-holidaymagic")
                APP_SOUND="$DIR_SOUND/teampixel/notifications/Seasonal Celebrations/Holiday Magic.ogg"
            break
            ;;
	"pixel-partyfavor")
                APP_SOUND="$DIR_SOUND/teampixel/notifications/Seasonal Celebrations/Party Favor.ogg"
            break
            ;;
        "pixel-sleighbells")
                APP_SOUND="$DIR_SOUND/teampixel/notifications/Seasonal Celebrations/Sleigh Bells.ogg"
            break
            ;;
        "pixel-snowflake")
                APP_SOUND="$DIR_SOUND/teampixel/notifications/Seasonal Celebrations/Snowflake.ogg"
            break
            ;;
        "pixel-summersurf")
                APP_SOUND="$DIR_SOUND/teampixel/notifications/Seasonal Celebrations/Summer Surf.ogg"
            break
            ;;
        "pixel-sweatheart")
                APP_SOUND="$DIR_SOUND/teampixel/notifications/Seasonal Celebrations/Sweetheart.ogg"
            break
            ;;
        "pixel-winterwind")
                APP_SOUND="$DIR_SOUND/teampixel/notifications/Seasonal Celebrations/Winter Wind.ogg"
            break
            ;;
	"pixel-chime")
                APP_SOUND="$DIR_SOUND/teampixel/notifications/Pixel Sounds/Chime.ogg"
            break
            ;;
	"pixel-clink")
                APP_SOUND="$DIR_SOUND/teampixel/notifications/Pixel Sounds/Clink.ogg"
            break
            ;;
	"pixel-flick")
                APP_SOUND="$DIR_SOUND/teampixel/notifications/Pixel Sounds/Flick.ogg"
            break
            ;;
	"pixel-hey")
                APP_SOUND="$DIR_SOUND/teampixel/notifications/Pixel Sounds/Hey.ogg"
            break
            ;;
	"pixel-note")
                APP_SOUND="$DIR_SOUND/teampixel/notifications/Pixel Sounds/Note.ogg"
            break
            ;;
	"pixel-strum")
                APP_SOUND="$DIR_SOUND/teampixel/notifications/Pixel Sounds/Strum.ogg"
            break
            ;;
	"pixel-trill")
                APP_SOUND="$DIR_SOUND/teampixel/notifications/Pixel Sounds/Trill.ogg"
            break
            ;;
	"x11")
                APP_SOUND="$DIR_SOUND/x11/stereo/message-new-instant.ogg"
            break
            ;;
        "x10")
                APP_SOUND="$DIR_SOUND/x10/stereo/window-attention-inactive.ogg"
            break
            ;;
        "x10-crystal")
                APP_SOUND="$DIR_SOUND/x10-crystal/stereo/message-new-instant.ogg"
            break
            ;;
        "xxp")
                APP_SOUND="$DIR_SOUND/xxp/stereo/message-new-instant.ogg"
            break
            ;;
	"miui")
                APP_SOUND="$DIR_SOUND/miui/stereo/message-sent-instant.ogg"
            break
            ;;
        "deepin")
                APP_SOUND="$DIR_SOUND/deepin/stereo/message.ogg"
            break
            ;;
        "borealis")
                APP_SOUND="$DIR_SOUND/borealis/stereo/message-new-instant-alt.ogg"
            break
            ;;
        "harmony")
                APP_SOUND="$DIR_SOUND/harmony/stereo/message-new-instant.ogg"
            break
            ;;
	"hydrogen")
                APP_SOUND="$DIR_SOUND/hydrogen/stereo/message-new-email.ogg"
            break
            ;;
        "dream")
                APP_SOUND="$DIR_SOUND/dream/stereo/battery-full.ogg"
            break
            ;;
        "zorin")
                APP_SOUND="$DIR_SOUND/zorin/stereo/success.ogg"
            break
            ;;
        "samsung-retro")
                APP_SOUND="$DIR_SOUND/samsung-retro/stereo/message-new-email.ogg"
            break
            ;;
        "ios-remix")
                APP_SOUND="$DIR_SOUND/ios-remix/stereo/message-new-instant.ogg"
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

    play "${APP_SOUND}"
}

# SET CUSTOM NOTIFICATION SOUND
choose_notif

while true
do
	read -p "[Q] Set this file as the custom notification sound, answer 'm' to choose again (y/n/m)? " answer
	case ${answer:0:1} in
    		y|Y|yes|Yes )

			if [[ "$APP_SOUND" != "none" ]]; then
			echo "[i] Custom notification sound set!"
			gsettings set org.cinnamon.sounds notification-file "$APP_SOUND"
			break
		fi
		;;
    		m|M|maybe|Maybe )

        		choose_notif
        		;;

    		n|N|no]No )
			echo "[i] Exiting..."
			break
			;;
    		* )
        	exit
    		;;
	esac
done

