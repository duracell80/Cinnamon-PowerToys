#!../bin/python3
import os, argparse
from datetime import datetime

dir_home = os.path.expanduser("~/")
dir_audio = f"{dir_home}/Audio/TTS/Auralis"

file_ts = str(int(datetime.today().timestamp()))

parser = argparse.ArgumentParser()
parser.add_argument("--voice", type = str, required = False, default = "default")
parser.add_argument("--text", type = str, required = False, default = "Some people call this artificial intelligence, but the reality is, that this technology will enhance us.")

args = parser.parse_args()

in_text = args.text

# Initialize
