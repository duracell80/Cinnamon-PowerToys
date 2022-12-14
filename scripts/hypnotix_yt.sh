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

# COLLECT LIVESTREAMS
$LWD/yt_channels.py

# COPY FROM CACHED M3U
cp $HWD/providers/yt-channels $LWD/iptv-youtube.m3u
cp $HWD/providers/yt-channels $CWD/iptv-youtube.m3u

HYP_GET=$(gsettings get org.x.hypnotix providers)

# SET AS HYPNOTIX PROVIDER
if [[ $HYP_GET == *"iptv-youtube"* ]]; then
    exit
else
    HYP_SET=$(gsettings get org.x.hypnotix providers | sed "s|:']|:', 'YouTube Live:::local:::file://${HOME}/.local/share/powertoys/iptv-youtube.m3u:::::::::']|" | uniq)

    gsettings set org.x.hypnotix providers "${HYP_SET}"
fi