#!/bin/bash

CWD=$(pwd)
LWD=$HOME/.local/share/powertoys
LBD=$HOME/.local/bin

if ! [ -x "$(which fortune)" ]; then
	sudo apt install fortunes
fi

if ! [ -x "$(which jq)" ]; then
        sudo apt install jq
fi

if ! [ -x "$(which xclip)" ]; then
        sudo apt install xclip
fi

if ! [ -x "$(which zenity)" ]; then
        sudo apt install zenity
fi


# Lock Screen
KEY_LG=$(gsettings get org.cinnamon.desktop.keybindings looking-glass-keybinding | grep -i "<super>l" | wc -l)

sudo cp -f $CWD/scripts/lock-screen.py /usr/bin/lock-screen
sudo cp -f $CWD/scripts/show-clip.sh /usr/bin/show-clip
sudo chmod a+x /usr/bin/lock-screen
sudo chmod a+x /usr/bin/show-clip


if [[ $KEY_LG == "1" ]]; then
	echo "[i] Setting Super L to lock screen"
	gsettings set org.cinnamon.settings-daemon.plugins.power lock-on-suspend "true"
	gsettings set org.cinnamon.desktop.screensaver allow-keyboard-shortcuts "true"
	gsettings set org.cinnamon.desktop.screensaver show-album-art "false"

	gsettings set org.cinnamon.desktop.screensaver show-info-panel "true"
	gsettings set org.cinnamon.desktop.lockdown disable-lock-screen "false"
	gsettings set org.cinnamon.desktop.screensaver allow-keyboard-shortcuts "true"

	gsettings set org.cinnamon.desktop.keybindings looking-glass-keybinding "['<Ctrl><Alt>l']"
	gsettings set org.cinnamon.settings-daemon.plugins.media-keys screensaver "['<Super>l']"

fi

# Show Desktop
KEY_SD=$(gsettings get org.cinnamon.desktop.keybindings.wm  show-desktop | grep -i "<super>d" | wc -l)
if [[ $KEY_SD == "1" ]]; then
        gsettings set org.cinnamon.desktop.keybindings.wm show-desktop "['<super>m']"
fi

# Assign workspace switcher to super
cp $HOME/.config/cinnamon/spices/grouped-window-list@cinnamon.org/2.json $HOME/.config/cinnamon/spices/grouped-window-list@cinnamon.org/2.json.orig
jq '."super-num-hotkeys".value = false' $HOME/.config/cinnamon/spices/grouped-window-list@cinnamon.org/2.json > /tmp/temp.json && mv /tmp/temp.json $HOME/.config/cinnamon/spices/grouped-window-list@cinnamon.org/2.json


# Backup from dconf and reset
if [ ! -f $PWD/scripts/dconf-keys.orig ]
then
    dconf dump /org/cinnamon/desktop/keybindings/ > scripts/dconf-keys.orig
else
    dconf load /org/cinnamon/desktop/keybindings/ < scripts/dconf-keys.conf
fi

dconf load /org/cinnamon/desktop/keybindings/ < scripts/dconf-keys.conf


#Power Options
gsettings set org.cinnamon.settings-daemon.plugins.power lid-close-ac-action "nothing"
gsettings set org.cinnamon.settings-daemon.plugins.power sleep-inactive-ac-timeout "0"
gsettings set org.cinnamon.settings-daemon.plugins.power button-power "blank"
gsettings set org.cinnamon.settings-daemon.plugins.power critical-battery-action "shutdown"
