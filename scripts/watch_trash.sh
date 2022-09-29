#!/bin/bash
# https://forums.linuxmint.com/viewtopic.php?t=304391

MSG_0=0

DIR_SOUND="/usr/share/sounds"
DIR_TRASH="$HOME/.local/share/Trash/files"


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

SOUND_THEME=$(gsettings get org.cinnamon.desktop.sound theme-name | sed "s/'/ /g" | xargs)

while true
do
    
    
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
    
    if [ "$TOT1" -gt "$TOT2" ];
    then
        MSG_0=0
        play_sound "trash-empty" $SOUND_THEME
    fi
    
    
    

done