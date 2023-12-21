#!/usr/bin/env python3
#
# this script will convert the hdhomerun listings (channels) to
# m3u format for use with external media players. before running
# this script, be sure to modify the <<config>> variable settings
# below.
#
# Suggested Usage: This script should be run on a cron to keep
# the channel lineup to date. Below is an example of how to execute this script:
# python /path/to/script/hdhomerun-prime-listings-to-m3u.py > /path/to/playlist.m3u
#
# original author Josh Kastang (josh[dot]kastang[at]gmail[dot]com)
# 
# Converted to Python 3 and revised to support Jellyfin by Casey Avila
# - Added automatic finding of HDHomeRun ip address
# - Added ability to opt out of duration
# 
# Use locally installed discovery service by Lee Jordan (git:duracell80)
# git clone https://github.com/Silicondust/libhdhomerun.git
# cd libhdhomerun && make

import requests, json, subprocess, os, re

dir_home = os.path.expanduser('~')

rc = subprocess.call(['hdhomerun_config', 'discover'])
if rc == 0:
    cmd = subprocess.Popen("hdhomerun_config discover -4", stdout=subprocess.PIPE, shell=True)
    (output, err) = cmd.communicate()
    cmd_status = cmd.wait()
    ip = re.findall(r'[0-9]+(?:\.[0-9]+){3}', str(output))
    
    ip_addr = str(ip[0])
    print(ip)
    config = {
        # Uses first HDHomeRun found on network
        'hdhr-ip'   : ip_addr,
        'duration'  : '7200',
    }
else:
    ip_request = requests.get("http://ipv4-api.hdhomerun.com/discover");
    config = {
        # Uses first HDHomeRun found on network
        'hdhr-ip'   : json.loads(ip_request.text)[0]["LocalIP"],
        'duration'  : '7200',
    }



use_duration = True 

os.system('touch '+ dir_home +'/.cache/hypnotix/providers/hd-homerun')



hdhr_url        = "http://{}/lineup.json?show=unprotected".format(config['hdhr-ip'])
response_obj    = requests.get(hdhr_url)
listings_res    = response_obj.text

m3u_out = "#EXTM3U\n"


listings = json.loads(listings_res)
for l in listings:
    channel = l['GuideNumber']
    name    = l['GuideName']

    m3u_out += '#EXTINF:-1 deinterlace=\"1\" tvg-chno="'+ channel +'" tvg-name="'+ name +'",'+ name + '\n'
    if use_duration:
        m3u_out += 'http://'+ config['hdhr-ip'] +':5004/auto/v'+ channel +'?duration=' + config['duration'] + '\n'
    else:
        m3u_out += 'http://'+ config['hdhr-ip'] +':5004/auto/v'+ channel +'\n'


text_file = open(dir_home + '/.cache/hypnotix/providers/hd-homerun', 'wt')
n = text_file.write(m3u_out)
text_file.close()
