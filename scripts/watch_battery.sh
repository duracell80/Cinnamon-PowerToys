#!/bin/bash
MSG_1=0
MSG_2=0
MSG_3=0
MSG_4=0
MSG_5=0
MSG_6=0

TIM=$(acpi -b | awk '{print $5}' | head -n 1)


DIR_SOUND="/usr/share/sounds"

play_sound () {
    SOUND_INDEX=$DIR_SOUND/${2}/index.theme
    
    # READ THE CONFIG
    SOUND_FILE=$(awk -F '=' '/^\s*'${1}'\s*=/ {
        sub(/^ +/, "", $2);
        sub(/ +$/, "", $2);
        print $2;
        exit;
    }' $SOUND_INDEX)
    
    SOUND_SET=$(echo $SOUND_FILE | tr -d \'\" )
    
    if [ "${1}" == "battery-low" ]; then
        play "${DIR_SOUND}/${SOUND_SET}" &
    fi
}

while true
do
    SOUND_THEME=$(gsettings get org.cinnamon.desktop.sound theme-name | sed "s/'/ /g" | xargs)
    LEV=$(acpi -b | awk '{print $4}' | head -n 1 | tr '%' ' ' | tr ',' ' ' | xargs)
    PWR=$(acpi -b | head -n 1 | grep -c "Charging")
    FUL=$(acpi -b | head -n 1 | grep -c "Full")
    
        
    # UNPLUGGED
    if [[ "$PWR" == 0 ]]; then
        
        gsettings set org.cinnamon.sounds notification-enabled false
        
        # ALERT 1 - HALF WAY EMPTY
        if [[ "$LEV" -gt 26 ]] && [[ "$LEV" -lt 50 ]]; then
            if [[ "$MSG_1" == 0 ]]; then
                MSG_1=1
                echo "Caution: battery halfway empty (${LEV}% - ${TIM})"
                notify-send --urgency=normal --category=device --icon=dialog-warning-symbolic "Battery Level Check - ${LEV}%" "The battery is less than halfway drained ( Remaining: ${TIM} )"
                
                play_sound "battery-low" $SOUND_THEME
            fi
        fi
        
        # ALERT 2 - QUARTER EMPTY
        if [[ "$LEV" -lt 26 ]]; then
            if [[ "$MSG_2" == 0 ]]; then
                MSG_2=1
                echo "Caution: battery quarter empty (${LEV}% - ${TIM})"
                notify-send --urgency=normal --category=device --icon=dialog-warning-symbolic --hint=string:sound-name:battery-low "Battery Level Check - ${LEV}%" "The battery is about a three quarters drained ( Remaining: ${TIM} )"
                
                play_sound "battery-low" $SOUND_THEME
            fi
        fi
        
        # ALERT 3 - 10% EMPTY
        if [[ "$LEV" -lt 11 ]]; then
            if [[ "$MSG_3" == 0 ]]; then
                MSG_3=1
                echo "Critical: battery almost exhusted (${LEV}% - ${TIM})"
                notify-send --urgency=normal --category=device --icon=dialog-warning-symbolic --hint=string:sound-name:battery-caution "Battery Level Check - ${LEV}%" "The battery is almost exhusted ( Remaining: ${TIM} )"
                
                play_sound "battery-caution" $SOUND_THEME
            fi
        fi
        
        # ALERT 4 - 5% EMPTY
        if [[ "$LEV" -lt 6 ]]; then
            if [[ "$MSG_4" == 0 ]]; then
                MSG_4=1
                echo "Critical: you should find a power source or suspend your computer (${LEV}% - ${TIM})"
                notify-send --urgency=normal --category=device --icon=dialog-warning-symbolic --hint=string:sound-name:battery-caution "Battery Level Check - ${LEV}%" "The battery level is critical, you should find a power source or suspend your computer very soon! ( Remaining: ${TIM} )"
                
                play_sound "battery-caution" $SOUND_THEME
            fi
        fi
        
        gsettings set org.cinnamon.sounds notification-enabled true
    fi

    # PLUGGED
    if [[ "$PWR" == 1 ]]; then
        if [[ "$MSG_5" == 0 ]]; then
            MSG_5=1
            play_sound "plug-file" $SOUND_THEME
        fi
        
        if [[ "$FUL" == 1 ]]; then
            if [[ "$MSG_6" == 0 ]]; then
                MSG_6=1
                play_sound "battery-full" $SOUND_THEME
            fi
        fi
    fi
    
    
    if [[ "$PWR" == 1 ]]; then
        sleep 3600
    else
        if [[ "$LEV" -gt 55 ]] && [[ "$LEV" -lt 101 ]]; then
            sleep 1200

        elif [[ "$LEV" -lt 56 ]]; then
            sleep 600

        elif [[ "$LEV" -lt 26 ]]; then
            sleep 400

        elif [[ "$LEV" -lt 16 ]]; then
            sleep 200

        elif [[ "$LEV" -lt 11 ]]; then
            sleep 30

        else
            sleep 60
        fi
    fi
    
    TIM=$(acpi -b | awk '{print $5}' | head -n 1)
done