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


while :
do
	# COLLECT LIVESTREAMS AND TIMEOUT TO DEAL WITH ADBLOCKERS
    T1=$(date +%s)
    timeout 60s $LWD/yt_channels.py
    T2=$(date +%s)
	
    T3=$((T2-T1))
    
    if [ $T3 -gt 55 ];then
        notify-send --urgency=normal --category=transfer.complete --icon=network-wired-symbolic "Hypnotix YouTube Error" "Timeout occured while fetching YouTube channels. There may be an adblocker present on your network or another tool that is enforcing safe search. Try adding youtube.com to the allow list. In adguard this would be @@||www.youtube.com^\$important."
    else
        # COPY FROM CACHED M3U
        cp $HWD/providers/yt-channels $LWD/iptv-youtube.m3u
        cp $HWD/providers/yt-channels $CWD/iptv-youtube.m3u
       
        HYP_GET=$(gsettings get org.x.hypnotix providers)

        # SET AS HYPNOTIX PROVIDER
        if [[ $HYP_GET == *"iptv-youtube"* ]]; then
            MSG_0=1
        else
            HYP_SET=$(gsettings get org.x.hypnotix providers | sed "s|:']|:', 'HDHomeRun:::local:::file://${HOME}/Videos/iptv-hd-homerun.m3u:::::::::']|" | uniq)
            gsettings set org.x.hypnotix providers "${HYP_SET}"
        fi
    fi
    
	sleep 18000
done