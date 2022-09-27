#!/bin/sh

FILE_DIR=$(dirname "$2")
FILE_BIT=$(basename "$2")

FILE_NME=${FILE_BIT%%.*}
FILE_EXT=${FILE_BIT##*.}

OUND_DIR=$HOME/.local/share/powertoys/sounds
mkdir -p $OUND_DIR


(
echo "35"
echo "# Setting ${1} sound as ${1}.${FILE_EXT}"

if [ "$1" = "startup" ]; then
    cp -f "$2" $OUND_DIR/startup.${FILE_EXT}
    gsettings set org.cinnamon.sounds login-file $OUND_DIR/startup.${FILE_EXT}
    gsettings set org.cinnamon.sounds login-enabled true
elif [ "$1" = "shutdown" ]; then
    cp -f "$2" $OUND_DIR/shutdown.${FILE_EXT}
    gsettings set org.cinnamon.sounds logout-file $OUND_DIR/shutdown.${FILE_EXT}
    gsettings set org.cinnamon.sounds logout-enabled true
elif [ "$1" = "notification" ]; then
    cp -f "$2" $OUND_DIR/notification.${FILE_EXT}
    gsettings set org.cinnamon.sounds notification-file $OUND_DIR/notification.${FILE_EXT}
    gsettings set org.cinnamon.sounds notification-enabled true
fi

echo "# Completed Setting ${FILE_NME}.${FILE_EXT} as $1"
echo "100" ; sleep 1
) |
zenity --progress \
  --title="Setting system sound" \
  --text="Running script ..." \
  --percentage=25 \
  --width=500 \
  --timeout=5

if [ "$?" = -1 ] ; then
        zenity --error \
          --text="Action canceled"
fi