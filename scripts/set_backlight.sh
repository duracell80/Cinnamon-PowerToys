#!/bin/sh


if [ -x "$(which brightnessctl)" ]; then

	KBD_MAX=$(brightnessctl --device='asus::kbd_backlight' info | grep -i "max brightness" | cut -d ":" -f2 | sed "s/ //g")
	KBD_NOW=$(brightnessctl --device='asus::kbd_backlight' info | grep -i "current brightness" | cut -d ":" -f2 | cut -d "(" -f2 | sed "s/%)//g" | sed "s/ //g")

	KBD_RES=$((`echo "$KBD_NOW < $KBD_MAX"| bc`))
    	if [ $1 = "on" ]; then
        	brightnessctl -q --device='asus::kbd_backlight' set $KBD_MAX
        	exit
    	elif [ $1 = "off" ]; then
       		brightnessctl -q --device='asus::kbd_backlight' set 0
        	exit
    	elif [ $1 = "ambient" ]; then
		# Does not store images and uses camera to determine ambient light levels

		if [ -x "$(which fswebcam)" ]; then
			LEV_MIN="0.4"
			LEV_LIGHT=$(ambientlight)

			if [ $(echo "${LEV_LIGHT} < ${LEV_MIN}" | bc -l) = 1 ]; then
				echo "Backlight was turned on"
				brightnessctl -q --device='asus::kbd_backlight' set $KBD_MAX
        			exit
			else
				echo "Backlight was turned off"
				brightnessctl -q --device='asus::kbd_backlight' set 0
				exit
			fi
		else
			exit
		fi
    	fi

    	# Failover to a toggle
    	if [ $KBD_RES = 1 ]; then
		brightnessctl -q --device='asus::kbd_backlight' set $KBD_MAX
        	exit
    	else
		brightnessctl -q --device='asus::kbd_backlight' set 0
       		exit
    	fi
fi
