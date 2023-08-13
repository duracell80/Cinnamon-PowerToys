#!/bin/bash
MSG_0=0
MSG_1=0
MSG_2=0
MSG_3=0
MSG_4=0
MSG_5=0
MSG_6=0

$HOME/.local/share/powertoys/watch_power.sh &

# MAKE IT IMPOSSIBLE TO RUN MORE THAN ONE INSTANCE OF THIS SCRIPT IN THIS CASE KILL THE PREVIOUS PID
PID_CURR=$$
PID_COUNT=$(ps aux | grep "watch_battery.sh" | head -n -1 | wc -l)

if [[ "$PID_COUNT" > 1 ]]; then
    PID_PREV=$(ps aux | grep "watch_battery.sh" | head -n -1 | head -n 1 | awk '{print $2}')
    if [[ "$PID_PREV" -ne "$PID_CURR" ]]; then
        kill $PID_PREV
    fi
fi

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

    if [ "${1}" == "battery-caution" ]; then
        play "${DIR_SOUND}/${SOUND_SET}" &
    fi
}

while true
do
    SOUND_THEME=$(gsettings get org.cinnamon.desktop.sound theme-name | sed "s/'/ /g" | xargs)
    #LEV=$(acpi -b | awk '{print $4}' | head -n 1 | tr '%' ' ' | tr ',' ' ' | xargs)

    BA1=$(acpi -b | grep -i "battery 0" | grep -ci "unavailable")
    BA2=$(acpi -b | grep -i "battery 1" | grep -ci "unavailable")
    BA3=$(acpi -b | grep -i "battery 2" | grep -ci "unavailable")

    if [[ "$BA1" == "0" ]]; then
	echo "[i] Battery 1 - Available"
	PWR=$(acpi -b | grep -i "battery 0" | grep "Charging")
	FUL=$(acpi -b | grep -i "battery 0" | grep "Full")

	LEV=$(cat /sys/class/power_supply/BAT0/capacity)
        MFG=$(cat /sys/class/power_supply/BAT0/manufacturer)
        MOD=$(cat /sys/class/power_supply/BAT0/model_name)

    elif [[ "$BA2" == "0" ]]; then
	echo "[i] Battery 2 - Available"
	PWR=$(acpi -b | grep -i "battery 1" | grep "Charging")
        FUL=$(acpi -b | grep -i "battery 1" | grep "Full")

	LEV=$(cat /sys/class/power_supply/BAT0/capacity)
        MFG=$(cat /sys/class/power_supply/BAT0/manufacturer)
        MOD=$(cat /sys/class/power_supply/BAT0/model_name)

    elif [[ "$BA3" == "0" ]]; then
	echo "[i] Battery 3 - Available"
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


    # UNPLUGGED
    if [[ "$PWR" == 0 ]]; then

        gsettings set org.cinnamon.sounds notification-enabled false
        # ALERT 1 - HALF WAY EMPTY
        if [[ "$LEV" -gt 26 ]] && [[ "$LEV" -lt 50 ]]; then
            if [[ "$MSG_1" == 0 ]]; then
                MSG_1=1
                echo "Caution: battery halfway empty (${LEV}% - ${TIM})"
                notify-send --urgency=low --category=device --icon=battery-good-symbolic "Battery Level Check - ${LEV}%" "The battery is less than halfway drained ( Remaining: ${TIM} )"

                play_sound "battery-low" $SOUND_THEME
                for i in {1..3}
                do
                    xdotool key XF86MonBrightnessDown
                done
            fi
        fi


        # ALERT 5 - SUSPEND SYSTEM WITH ENOUGH POWER TO RETAIN DATA
        if [[ "$LEV" -lt 8 ]] && [[ "$LEV" -gt 2 ]]; then
            if [[ "$MSG_0" == 0 ]]; then
                MSG_0=1
                MSG_1=1
                MSG_2=1
                MSG_3=1
                MSG_4=1
                MSG_5=1
                echo "Critical: you should find a power source or suspend your computer (${LEV}% - ${TIM})"
                notify-send --urgency=critical --category=device --icon=battery-empty-symbolic --hint=string:sound-name:battery-caution "Battery Level Check - ${LEV}%" "To safeguard your data your computer will suspend (and not power off) within the next 30 seconds. Please save your work!"

                play_sound "battery-caution" $SOUND_THEME
                sleep 30
                systemctl suspend
            fi
        fi

        # ALERT ALMOST EMPTY
        if [[ "$LEV" -lt 11 ]] && [[ "$LEV" -gt 8 ]]; then
            if [[ "$MSG_4" == 0 ]]; then
                MSG_4=1
                echo "Critical: you should find a power source or suspend your computer (${LEV}% - ${TIM})"
                notify-send --urgency=normal --category=device --icon=battery-caution-symbolic --hint=string:sound-name:battery-caution "Battery Level Check - ${LEV}%" "The battery level is very low, you should find a power source or suspend your computer very soon! ( Remaining: ${TIM} )"

                play_sound "battery-caution" $SOUND_THEME
                for i in {1..5}
                do
                    xdotool key XF86MonBrightnessDown
                done

                gnome-power-statistics
            fi
        fi

        # ALERT NEARLY EMPTY
        if [[ "$LEV" -lt 13 ]] && [[ "$LEV" -gt 8 ]]; then
            if [[ "$MSG_3" == 0 ]]; then
                MSG_3=1
                echo "Critical: battery almost exhusted (${LEV}% - ${TIM})"
                notify-send --urgency=normal --category=device --icon=battery-low-symbolic --hint=string:sound-name:battery-caution "Battery Level Check - ${LEV}%" "The battery is almost exhusted ( Remaining: ${TIM} )"
                play_sound "battery-caution" $SOUND_THEME
                for i in {1..2}
                do
                    xdotool key XF86MonBrightnessDown
                done
            fi
        fi

        # ALERT 2 - QUARTER EMPTY
        if [[ "$LEV" -lt 26 ]] && [[ "$LEV" -gt 10 ]]; then
            if [[ "$MSG_2" == 0 ]]; then
                MSG_2=1
                echo "Caution: battery quarter empty (${LEV}% - ${TIM})"
                notify-send --urgency=normal --category=device --icon=battery-good-symbolic --hint=string:sound-name:battery-low "Battery Level Check - ${LEV}%" "The battery is about a three quarters drained ( Remaining: ${TIM} )"

                play_sound "battery-low" $SOUND_THEME
                for i in {1..4}
                do
                    xdotool key XF86MonBrightnessDown
                done
            fi
        fi

        gsettings set org.cinnamon.sounds notification-enabled true
    fi

    # PLUGGED
    if [[ "$PWR" == 1 ]]; then
        if [[ "$MSG_5" == 0 ]]; then
            MSG_5=1
            #play_sound "plug-file" $SOUND_THEME
        fi

        if [[ "$FUL" == 1 ]]; then
            if [[ "$MSG_6" == 0 ]]; then
                MSG_6=1
                gsettings set org.cinnamon.sounds notification-enabled false
                play_sound "battery-full" $SOUND_THEME
                gsettings set org.cinnamon.sounds notification-enabled true


                notify-send --urgency=normal --category=device --icon=battery-full-symbolic --hint=string:sound-name:battery-full "Battery Fully Charged - ${LEV}%" "If needed, search for ${MOD} ${MFG} to find replacement batteries"

            fi
        fi
    fi


    if [[ "$PWR" == 1 ]]; then
        sleep 3600
    else
        if [[ "$LEV" -gt 55 ]] && [[ "$LEV" -lt 101 ]]; then
            sleep 2400

        elif [[ "$LEV" -lt 56 ]]; then
            sleep 2400

        elif [[ "$LEV" -lt 26 ]]; then
            sleep 1200

        elif [[ "$LEV" -lt 16 ]]; then
            sleep 600

        elif [[ "$LEV" -lt 11 ]]; then
            sleep 300
        else
            sleep 180
        fi
    fi

    TIM=$(acpi -b | awk '{print $5}' | head -n 1)
done
