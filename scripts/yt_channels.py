#! /usr/bin/python3

import requests, os, sys

m3u_out     = "#EXTM3U\n"
dir_home    = os.path.expanduser('~')

def grab(url):
    response = requests.get(url, timeout=15).text
    end = response.find('.m3u8') + 5
    tuner = 100
    while True:
        if 'https://' in response[end-tuner : end]:
            link = response[end-tuner : end]
            start = link.find('https://')
            end = link.find('.m3u8') + 5
            break
        else:
            tuner += 5
    return f"\n{link[start : end]}"

file_exists = os.path.exists(dir_home + '/Videos/yt_channels.txt')
if file_exists:
    file_channels = dir_home + '/Videos/yt_channels.txt'
else:
    file_channels = dir_home + '/.cache/hypnotix/yt_channels.txt'
    
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
            m3u_out += '\n#EXTINF:-1 group-title="' + grp_title + '" tvg-logo="' + tvg_logo + '" tvg-id="' + tvg_id +'", ' + ch_name
        else:
            m3u_out += grab(line)
            
text_file = open(dir_home + '/.cache/hypnotix/providers/yt-channels', 'wt')
n = text_file.write(m3u_out)
text_file.close()