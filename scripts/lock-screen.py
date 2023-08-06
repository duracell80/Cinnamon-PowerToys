#!/usr/bin/python3

import os
import subprocess

def lock_screen():
	# Add commands here to run when screen locks

	#message = subprocess.check_output(['fortune', '-s'])
	message = ""
	if message != "":
		subprocess.call(["cinnamon-screensaver-command", "--lock", "--away-message", str(message)])
	else:
		subprocess.call(["cinnamon-screensaver-command", "--lock"])

if __name__ == "__main__":
	lock_screen()
