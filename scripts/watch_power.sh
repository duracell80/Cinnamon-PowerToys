#!/bin/bash
MSG_0=0
MSG_1=0


# MAKE IT IMPOSSIBLE TO RUN MORE THAN ONE INSTANCE OF THIS SCRIPT IN THIS CASE KILL THE PREVIOUS PID
PID_CURR=$$
PID_COUNT=$(ps aux | grep "watch_power.sh" | head -n -1 | wc -l)

if [[ "$PID_COUNT" > 1 ]]; then
    PID_PREV=$(ps aux | grep "watch_power.sh" | head -n -1 | head -n 1 | awk '{print $2}')
    if [[ "$PID_PREV" -ne "$PID_CURR" ]]; then
        kill $PID_PREV
    fi
fi

PWR=$(cat /sys/class/power_supply/AC/online)
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
    
    # ONLY PLAY THE SOUNDS RELEVANT
    if [ "${1}" == "power-plug" ]; then
        play "${DIR_SOUND}/${SOUND_SET}" &
    fi
    
    if [ "${1}" == "power-unplug" ]; then
        play "${DIR_SOUND}/${SOUND_SET}" &
    fi
    
    if [ "${1}" == "battery-caution" ]; then
        play "${DIR_SOUND}/${SOUND_SET}" &
    fi
    
    if [ "${1}" == "battery-full" ]; then
        play "${DIR_SOUND}/${SOUND_SET}" &
    fi
}

while true
do
    SOUND_THEME=$(gsettings get org.cinnamon.desktop.sound theme-name | sed "s/'/ /g" | xargs)
    PWR_NOW=$(cat /sys/class/power_supply/AC/online)
    
    #LEV=$(acpi -b | awk '{print $4}' | head -n 1 | tr '%' ' ' | tr ',' ' ' | xargs)
    LEV=$(cat /sys/class/power_supply/BAT0/capacity)
    MFG=$(cat /sys/class/power_supply/BAT0/manufacturer)
    MOD=$(cat /sys/class/power_supply/BAT0/model_name)
    if [[ "$LEV" -lt 1 ]]; then
        LEV=$(cat /sys/class/power_supply/BAT1/capacity)
        MFG=$(cat /sys/class/power_supply/BAT1/manufacturer)
        MOD=$(cat /sys/class/power_supply/BAT1/model_name)
    fi
    
    if [[ "$PWR_NOW" == 1 ]]; then
        # SUPRESS POSSIBILITY OF REPEATED NOTIFICATIONS AT 100% WHEN PLUGGED IN
        if [[ "$LEV" -gt 98 ]] && [[ "$LEV" -lt 100 ]]; then
            if [[ "$MSG_0" == 0 ]]; then
                # SUPRESS NOTIFICATIONS WHEN PLUGGED IN AND ALERTED AT LEAST ONCE
                MSG_0=1
                MSG_1=1
                notify-send --urgency=normal --category=device --icon=battery-full-symbolic --hint=string:sound-name:battery-full "Battery Fully Charged - ${LEV}%" "The power cable can now be unplugged!"
            fi
        fi
    fi
    
    # DETECT STATE CHANGE
    if [[ "$PWR_NOW" -ne "$PWR_LAST" ]]; then
        
        # PLUGGED
        if [[ "$PWR_NOW" == 1 ]]; then
            #echo "Power Plugged"
            if [[ "$LEV" -gt 89 ]] && [[ "$LEV" -lt 101 ]]; then
                if [[ "$MSG_1" == 0 ]]; then
                    MSG_1=1
                    play_sound "battery-full" $SOUND_THEME

                    notify-send --urgency=normal --category=device --icon=battery-good-symbolic --hint=string:sound-name:battery-full "Battery Adequately Charged - ${LEV}%" "The power cable can now be unplugged!"
                fi
            else
                play_sound "power-plug" $SOUND_THEME
            fi

        else
        # UNPLUGGED
            #echo "Power Unplugged"
            if [[ "$LEV" -lt 21 ]] && [[ "$LEV" -gt 2 ]]; then
                MSG_0=0
                play_sound "battery-caution" $SOUND_THEME
                sleep 5
                
                notify-send --urgency=normal --category=device --icon=battery-low-symbolic --hint=string:sound-name:battery-caution "Battery Level Check - ${LEV}%" "The battery is low!"
                
            else
                MSG_1=0
                play_sound "power-unplug" $SOUND_THEME
            fi
        fi
    fi

    PWR_LAST=$(cat /sys/class/power_supply/AC/online)
    if [[ "$PWR" == 1 ]]; then
        sleep 3
    else
        sleep 4
    fi
done