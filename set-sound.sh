#!/bin/bash

CWD=$(pwd)
LWD=$HOME/.local/share/powertoys
LBD=$HOME/.local/bin

# Set Default Sound Output
if ! [ -x "$(which pavucontrol)" ]; then
    sudo apt-get install pavucontrol
    echo "options snd-hda-intel model=generic" | sudo tee -a /etc/modprobe.d/alsa-base.conf
    aplay /usr/share/sounds/alsa/Front_Center.wav
fi

groups
dmesg | grep -C1 -E 'ALSA|HDA|HDMI|snd[_-]|sound|hda.codec|hda.intel'
pacmd list-sinks
aplay -l
rm -f ~/.config/pulse/*

sudo modprobe snd_hda_codec_realtek
pacmd set-default-sink alsa_output.pci-0000_04_00.6.analog-stereo
pacmd set-card-profile alsa_card.pci-0000_04_00.6 output:analog-stereo+input:analog-stereo

LC_ALL=C systemctl --user unmask pulseaudio.{service,socket} --now
LC_ALL=C systemctl --user restart pulseaudio

sudo alsa force-reload
sleep 10
pulseaudio -k
sleep 10
aplay /usr/share/sounds/alsa/Front_Center.wav

pa-info

systemctl --user status pulseaudio
