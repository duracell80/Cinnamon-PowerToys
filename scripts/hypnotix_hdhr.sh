#!/bin/bash
# https://forums.linuxmint.com/viewtopic.php?t=304391
# provider default: ['Free-TV:::url:::https://raw.githubusercontent.com/Free-TV/IPTV/master/playlist.m3u8:::::::::']
# provider additional: 'HDHomerun:::local:::file:///~/.local/share/powertoys/iptv-hd-homerun.m3u:::::::::'

MSG_0=0

LWD="$HOME/.local/share/powertoys"
CWD="$HOME/.cache/powertoys"
HWD="$HOME/.cache/hypnotix"

mkdir -p $CWD
mkdir -p $HWD
#mkdir -p $HWD/providers/hdhomerun

# COPY FROM TUNER CACHED M3U
cp -f $HWD/providers/hd-homerun $LWD/iptv-hd-homerun.m3u
cp -f $HWD/providers/hd-homerun $CWD/iptv-hd-homerun.m3u

HYP_GET=$(gsettings get org.x.hypnotix providers)

# SET AS HYPNOTIX PROVIDER
if [[ $HYP_GET == *"homerun"* ]]; then
    exit
else
    HYP_SET=$(gsettings get org.x.hypnotix providers | sed "s|:']|:', 'HDHomeRun:::local:::file://${HOME}/.local/share/powertoys/iptv-hd-homerun.m3u:::::::::']|" | uniq)

    gsettings set org.x.hypnotix providers "${HYP_SET}"
fi
