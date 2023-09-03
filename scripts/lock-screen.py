#!/usr/bin/python3

import os, subprocess, time

def lock_screen():
	# Add commands here to run when screen locks
	DIR_HOME = os.path.expanduser('~')

	# Get current background
	os.system(f"mkdir -p {DIR_HOME}/.local/state/screensaver")
	os.system(f"touch {DIR_HOME}/.local/state/screensaver/bg_restore.txt")
	os.system(f"gsettings get org.cinnamon.desktop.background picture-uri > {DIR_HOME}/.local/state/screensaver/bg_restore.txt")

	# Swap for the lock screen background
	os.system(f"gsettings set org.cinnamon.desktop.background picture-uri $(cat {DIR_HOME}/.local/state/screensaver/bg_lock.txt)")
	#time.sleep(2)

	#message = subprocess.check_output(['fortune', '-s'])
	message = ""
	if message != "":
		subprocess.call(["cinnamon-screensaver-command", "--lock", "--away-message", str(message)])
	else:
		subprocess.call(["cinnamon-screensaver-command", "--lock"])

	# Run command to restore user background
	# gsettings set org.cinnamon.desktop.background picture-uri $(cat ~/.local/state/screensaver/bg_restore.txt)

if __name__ == "__main__":
	lock_screen()
