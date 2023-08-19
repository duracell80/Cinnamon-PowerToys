#!/bin/bash
# https://forums.linuxmint.com/viewtopic.php?t=304391

MSG_0=0

DIR_SOUND="/usr/share/sounds"
DIR_TRASH="$HOME/.local/share/Trash/files"
USE_FLATP=$(du -h /var/lib/flatpak/ | tail -n1 | cut -d "/" -f1 | sed 's/ //g')
USE_TRASH=$(du -h $HOME/.local/share/Trash | tail -n1 | cut -d "/" -f1 | sed 's/ //g')



USE_DIR=$HOME/.local/state
FILE_FLAT=$USE_DIR/flatpak/storage.txt
FILE_TRSH=$USE_DIR/disk/trash.txt

flatpak list > $USE_DIR/flatpak/installed.txt



if [ ! -f "$FILE_FLAT" ]; then
	mkdir -p $USE_DIR/flatpak
	echo "${USE_FLATP}" > $FILE_FLAT
else
	# ALERT FLATPAK STORAGE USAGE EVERY OTHER MONTH
        if test `find $FILE_FLAT -mmin +87600`
        then
		echo "${USE_FLATP}" > $FILE_FLAT
		notify-send --urgency=low --category=device --icon=drive-harddisk-symbolic "Flatpak Capacity Check - ${USE_FLATP}" "Installing flatpaks can take a lot of disk space, take the opportunity once a month to evaluate installed apps and remove ones not being used often to save disk space"
	fi
fi

if [ ! -f "$FILE_TRSH" ]; then
        mkdir -p $USE_DIR/disk
        echo "${USE_TRASH}" > $FILE_TRSH
else
        # ALERT TRASH STORAGE USAGE EVERY MONTH
        if test `find $FILE_TRSH -mmin +43800`
        then
                echo "${USE_TRASH}" > $FILE_TRSH
                notify-send --urgency=low --category=device --icon=user-trash-symbolic "Trash Capacity Check - ${USE_TRASH}" "Take the opportunity once a month to empty the trash using the icon in the sidebar in Nemo"
        fi
fi




# MAKE IT IMPOSSIBLE TO RUN MORE THAN ONE INSTANCE OF THIS SCRIPT IN THIS CASE KILL THE PREVIOUS PID
PID_CURR=$$
PID_COUNT=$(ps aux | grep "watch_trash.sh" | head -n -1 | wc -l)

if [[ "$PID_COUNT" > 1 ]]; then
    PID_PREV=$(ps aux | grep "watch_trash.sh" | head -n -1 | head -n 1 | awk '{print $2}')
    if [[ "$PID_PREV" -ne "$PID_CURR" ]]; then
        kill $PID_PREV
    fi
fi

play_sound () {
    SOUND_INDEX=$DIR_SOUND/${2}/index.theme
    SOUND_FILE=$(awk -F '=' '/^\s*'${1}'\s*=/ {
        sub(/^ +/, "", $2);
        sub(/ +$/, "", $2);
        print $2;
        exit;
    }' $SOUND_INDEX)

    SOUND_SET=$(echo $SOUND_FILE | tr -d \'\" )
    play "${DIR_SOUND}/${SOUND_SET}"
}



while true
do
    SOUND_THEME=$(gsettings get org.cinnamon.desktop.sound theme-name | sed "s/'/ /g" | xargs)
    
    TOT1=$(ls -1 $DIR_TRASH | wc -l)
    SIZF=$(du -b $DIR_TRASH | awk '{print $1}')
    SIZH=$(du -h $DIR_TRASH | awk '{print $1}')
    SIZE="$((SIZF-14000))"
    
    sleep 2
    TOT2=$(ls -1 $DIR_TRASH | wc -l)
    
    
    # ALERT IF APPROACHING 45GB TRASH
    if [[ "$SIZE" -gt 42949672960 ]]; then
        if [[ "$MSG_0" == 0 ]]; then
            MSG_0=1
            
            notify-send --urgency=normal --category=device --icon=user-trash-symbolic "Trash Is Getting Full ( ${SIZH} )" "The trash is getting too full. Disk space can be reclaimed by emptying the trash."
        fi
        
    fi
    
    if [ "$TOT1" -gt "$TOT2" ]; then
        MSG_0=0
        play_sound "trash-empty" $SOUND_THEME
    fi
    
    if [ "$TOT1" -ne "$TOT2" ]; then
        if [ "$TOT1" -lt "$TOT2" ]; then
            play_sound "file-trash" $SOUND_THEME
        fi
    fi
    
    #echo $TOT1
    #echo $TOT2

done
