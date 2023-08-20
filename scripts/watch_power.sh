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


AC1=$(acpi -V | grep -ci "adapter 0")
AC2=$(acpi -V | grep -ci "adapter 1")


#PWR=$(cat /sys/class/power_supply/AC/online)
if [[ "$AC1" == "1" ]]; then
	PWR=$(acpi -V | grep -i "adapter 0" | grep -ci "on-line")
	echo "[i] Adapter 1 Detected [${PWR}]"
elif [[ "$AC2" == "1" ]]; then
        PWR=$(acpi -V | grep -i "adapter 1" | grep -ci "on-line")
	echo "[i] Adapter 1 Detected [${PWR}]"
else
        PWR="0"
fi


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

    if [[ "$SOUND_SET" == "" ]];then
        SOUND_SET="harmony/stereo/power-unplug.ogg"
    fi


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
    echo "[i] Watching for power events ..."
    SOUND_THEME=$(gsettings get org.cinnamon.desktop.sound theme-name | sed "s/'/ /g" | xargs)
    if [[ "$SOUND_THEME" == "" ]];then
	SOUND_THEME="harmony"
    fi
    #PWR_NOW=$(cat /sys/class/power_supply/AC/online)

    if [[ "$AC1" == "1" ]]; then
        PWR_NOW=$(acpi -V | grep -i "adapter 0" | grep -ci "on-line")
    elif [[ "$AC2" == "1" ]]; then
	PWR_NOW=$(acpi -V | grep -i "adapter 1" | grep -ci "on-line")
    else
	PWR_NOW="0"
    fi

    #LEV=$(acpi -b | awk '{print $4}' | head -n 1 | tr '%' ' ' | tr ',' ' ' | xargs)
    BA1=$(acpi -b | grep -i "battery 0" | grep -ci "unavailable")
    BA2=$(acpi -b | grep -i "battery 1" | grep -ci "unavailable")
    BA3=$(acpi -b | grep -i "battery 2" | grep -ci "unavailable")

    if [[ "$BA1" == "0" ]]; then
        PWR=$(acpi -b | grep -i "battery 0" | grep "Charging")
        FUL=$(acpi -b | grep -i "battery 0" | grep "Full")

        LEV=$(cat /sys/class/power_supply/BAT0/capacity)
        MFG=$(cat /sys/class/power_supply/BAT0/manufacturer)
        MOD=$(cat /sys/class/power_supply/BAT0/model_name)

    elif [[ "$BA2" == "0" ]]; then
        PWR=$(acpi -b | grep -i "battery 1" | grep "Charging")
        FUL=$(acpi -b | grep -i "battery 1" | grep "Full")

        LEV=$(cat /sys/class/power_supply/BAT0/capacity)
        MFG=$(cat /sys/class/power_supply/BAT0/manufacturer)
        MOD=$(cat /sys/class/power_supply/BAT0/model_name)

    elif [[ "$BA3" == "0" ]]; then
        PWR=$(acpi -b | grep -i "battery 2" | grep "Charging")
        FUL=$(acpi -b | grep -i "battery 2" | grep "Full")

        LEV=$(cat /sys/class/power_supply/BAT0/capacity)
        MFG=$(cat /sys/class/power_supply/BAT0/manufacturer)
        MOD=$(cat /sys/class/power_supply/BAT0/model_name)

    else
        echo "[!] Batteries Not Included"
        PWR="0"
        FUL="0"
        LEV="0"
        MFG="Acme Batteries"
        MOD="BA000"
    fi


    if [[ "$PWR_NOW" == "1" ]]; then
        # SUPRESS POSSIBILITY OF REPEATED NOTIFICATIONS AT 100% WHEN PLUGGED IN
        if [[ "$LEV" -gt 98 ]] && [[ "$LEV" -lt 100 ]]; then
            if [[ "$MSG_0" == 0 ]]; then
                # SUPRESS NOTIFICATIONS WHEN PLUGGED IN AND ALERTED AT LEAST ONCE
                MSG_0=1
                MSG_1=1
		gsettings set org.cinnamon.sounds notification-enabled false
		sleep 1
                notify-send --urgency=normal --category=device --icon=battery-full-symbolic --hint=string:sound-name:battery-full "Battery Fully Charged - ${LEV}%" "The power cable can now be unplugged!"
            	gsettings set org.cinnamon.sounds notification-enabled true
		fi
        fi
    fi

    # DETECT STATE CHANGE
    if [[ "$PWR_NOW" -ne "$PWR_LAST" ]]; then

        # PLUGGED
        if [[ "$PWR_NOW" == "1" ]]; then
            echo "[i] Power Plugged"
		for i in {1..3}
                do
                    xdotool key XF86MonBrightnessUp
                done

            if [[ "$LEV" -gt 89 ]] && [[ "$LEV" -lt 101 ]]; then
                if [[ "$MSG_1" == 0 ]]; then
                    MSG_1=1
                    play_sound "battery-full" $SOUND_THEME
		    gsettings set org.cinnamon.sounds notification-enabled false
		    sleep 1
                    notify-send --urgency=normal --category=device --icon=battery-good-symbolic --hint=string:sound-name:battery-full "Battery Adequately Charged - ${LEV}%" "The power cable can now be unplugged!"
                    gsettings set org.cinnamon.sounds notification-enabled true
		fi
            else
                play_sound "power-plug" $SOUND_THEME
            fi

        else
        # UNPLUGGED
            echo "[i] Power Unplugged"
		for i in {1..5}
                do
                    xdotool key XF86MonBrightnessDown
                done
            if [[ "$LEV" -lt 21 ]] && [[ "$LEV" -gt 2 ]]; then
                MSG_0=0
                play_sound "battery-caution" $SOUND_THEME
                gsettings set org.cinnamon.sounds notification-enabled false
		sleep 5

                notify-send --urgency=normal --category=device --icon=battery-low-symbolic --hint=string:sound-name:battery-caution "Battery Level Check - ${LEV}%" "The battery is low!"
		gsettings set org.cinnamon.sounds notification-enabled true
            else
                MSG_1=0
                play_sound "power-unplug" $SOUND_THEME
            fi
        fi
    fi

    #PWR_LAST=$(cat /sys/class/power_supply/AC/online)
    if [[ "$AC1" == "1" ]]; then
        PWR_LAST=$(acpi -V | grep -i "adapter 0" | grep -ci "on-line")
    elif [[ "$AC2" == "1" ]]; then
        PWR_LAST=$(acpi -V | grep -i "adapter 1" | grep -ci "on-line")
    else
        PWR_LAST="0"
    fi

    if [[ "$PWR" == "1" ]]; then
        sleep 1
    else
        sleep 2
    fi
done
