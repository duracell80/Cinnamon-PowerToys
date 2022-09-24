#!/bin/bash
MSG_1=0
MSG_2=0
MSG_3=0
MSG_4=0

MSG_5=0

while true
do
    LEV=$(acpi -b | awk '{print $4}' | head -n 1 | tr '%' ' ' | tr ',' ' ')
    PWR=$(acpi -b | head -n 1 | grep -c "Charging")
    FUL=$(acpi -b | head -n 1 | grep -c "Full")
    
    
    # UNPLUGGED
    if [[ "$PWR" == 0 ]]; then
    
        # ALERT 1 - HALF WAY EMPTY
        if [[ "$LEV" > 49 ]] && [[ "$LEV" < 51 ]]; then
            if [[ "$MSG_1" == 0 ]]; then
                MSG_1=1
                echo "Caution: battery halfway empty"
            fi
        fi
        
        # ALERT 2 - QUARTER EMPTY
        if [[ "$LEV" > 24 ]] && [[ "$LEV" < 26 ]]; then
            if [[ "$MSG_2" == 0 ]]; then
                MSG_2=1
                echo "Caution: battery quarter empty"
            fi
        fi
        
        # ALERT 3 - 10% EMPTY
        if [[ "$LEV" > 9 ]] && [[ "$LEV" < 11 ]]; then
            if [[ "$MSG_3" == 0 ]]; then
                MSG_3=1
                echo "Critical: battery almost exhusted"
            fi
        fi
        
        # ALERT 4 - 5% EMPTY
        if [[ "$LEV" > 4 ]] && [[ "$LEV" < 6 ]]; then
            if [[ "$MSG_4" == 0 ]]; then
                MSG_4=1
                echo "Critical: you should find a power source or suspend your computer"
            fi
        fi
        
        
    fi

    # PLUGGED
    if [[ "$PWR" == 1 ]]; then
        if [[ "$MSG_5" == 0 ]]; then
            MSG_5=1
            echo "Information: computer plugged in and charging (${LEV})"
        fi
        
        if [[ "$FUL" == 1 ]]; then
            echo "Battery Full"
        fi

    fi
    sleep 30
done