#!/usr/bin/env python3
import os, sys, getopt
from gtts import gTTS


def main(argv):
    DIR_ASSET="/tmp"
    cfg_accent="com"
    cfg_language="en"
    
    
    try:
        opts, args = getopt.getopt(argv,"h:f:l:a:",["file=","lang=","accent="])
    except getopt.GetoptError:
        print('read_aloud.py -f <file> -l <lang> -a <accent>')
        sys.exit(2)
    for opt, arg in opts:
        if opt == '-h':
            print ('read_aloud.py -f <file> -l <lang> -a <accent>')
            sys.exit()
        elif opt in ("-f", "--file"):
            cfg_file = arg
        elif opt in ("-l", "--language"):
            cfg_language = arg
        elif opt in ("-a", "--accent"):
            cfg_accent = arg

    if cfg_accent == "british":
        cfg_accent = "co.uk"
        cfg_language = "en"
    elif cfg_accent == "australian":
        cfg_accent = "com.au"
        cfg_language = "en"
    elif cfg_accent == "canadian":
        cfg_accent = "ca"
    elif cfg_accent == "indian":
        cfg_accent = "co.in"
        cfg_language = "en"
    elif cfg_accent == "french":
        cfg_accent = "fr"
        cfg_language = "fr"
    elif cfg_accent == "portuguese":
        cfg_accent = "pt"
        cfg_language = "pt"
    elif cfg_accent == "spanish":
        cfg_accent = "es"
        cfg_language = "es"
    elif cfg_accent == "mexican":
        cfg_accent = "com.mx"
        cfg_language = "es"
    else:
        cfg_accent = "com"
        cfg_language = "en"
        
    # OPEN THE TEXT FILE
    if ".txt" in cfg_file:
        with open(cfg_file) as fp:
            filestring = fp.read()

        # GOOGLE TTS
        tts = gTTS(filestring, lang=cfg_language, tld=cfg_accent)
        tts.save(DIR_ASSET + '/read_aloud.mp3')
        os.system("ffmpeg -y -i " + DIR_ASSET + "/read_aloud.mp3 -acodec pcm_u8 -ar 22050 " + DIR_ASSET + "/read_aloud.wav")
        os.system("play "+ DIR_ASSET +"/read_aloud.wav")
    
    
    
    
if __name__ == "__main__":
    main(sys.argv[1:])