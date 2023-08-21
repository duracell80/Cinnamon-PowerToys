#!/bin/sh

if [ -x "$(which brightnessctl)" ]; then
	KBD_MAX=$(brightnessctl --device='asus::kbd_backlight' info | grep -i "max brightness" | cut -d ":" -f2 | sed "s/ //g")
	KBD_NOW=$(brightnessctl --device='asus::kbd_backlight' info | grep -i "current brightness" | cut -d ":" -f2 | cut -d "(" -f2 | sed "s/%)//g" | sed "s/ //g")

	KBD_RES=$((`echo "$KBD_NOW < $KBD_MAX"| bc`))
	if [ $KBD_RES -eq 1 ]
	then
		brightnessctl -q --device='asus::kbd_backlight' set $KBD_MAX
	else
		brightnessctl -q --device='asus::kbd_backlight' set 0
	fi
fi
