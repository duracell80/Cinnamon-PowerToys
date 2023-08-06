#! /usr/bin/python3

import requests, os, sys, re

m3u_out     = "#EXTM3U\n"
dir_home    = os.path.expanduser('~')

def grab(url):
    print("[i] Attempting to read " + url)
    response = requests.get(url, timeout=15).text
    end = response.find('.m3u8') + 5
    tuner = 100
    
    while True:
        if 'https://' in response[end-tuner : end]:
            link = response[end-tuner : end]
            start = link.find('http://')
            end = link.find('.m3u8') + 5
            break
        else:
            tuner += 5
    
    url = re.findall("(?P<url>https?://[^\s]+)", link)    
    return url[0]
    



file_exists = os.path.exists(dir_home + '/Videos/IPTV/yt_channels.txt')
if file_exists:
    file_channels = dir_home + '/Videos/IPTV/yt_channels.txt'
else:
    file_channels = dir_home + '/.cache/hypnotix/yt_channels.txt'

print("[i] Building M3U from " + file_channels)
with open(file_channels) as f:
    for line in f:
        line = line.strip()
        if not line or line.startswith('#'):
            continue
        if not line.startswith('https:'):
            line = line.split('|')
            ch_name = line[0].strip()
            grp_title = line[1].strip().title()
            tvg_logo = line[2].strip()
            tvg_id = line[3].strip()
            m3u_out += '\n#EXTINF:-1 group-title="' + grp_title + '" tvg-logo="' + tvg_logo + '" tvg-id="' + tvg_id +'", ' + ch_name + '\n'
        else:
            m3u_out += grab(line)

print("[i] Writing M3U")
text_file  = open(dir_home + '/.cache/hypnotix/providers/yt-channels', 'wt')
n = text_file.write(m3u_out)
text_file.close()

os.system("cp " + dir_home + "/.cache/hypnotix/providers/yt-channels " + dir_home + "/.local/share/powertoys/iptv-youtube.m3u")
os.system("cp " + dir_home + "/.cache/hypnotix/providers/yt-channels " + dir_home + "/Videos/IPTV/iptv.m3u.youtube")
print("[i] Done")