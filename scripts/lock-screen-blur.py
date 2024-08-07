#!/usr/bin/python3

import os, subprocess, time
from PIL import Image
from PIL import ImageFilter

def file_age(filepath):
	return time.time() - os.path.getmtime(filepath)

def lock_screen():
	# Add commands here to run when screen locks
	DIR_HOME = os.path.expanduser('~')

	# Get current background
	os.system(f"mkdir -p {DIR_HOME}/.local/state/screensaver")
	os.system(f"touch {DIR_HOME}/.local/state/screensaver/bg_restore.txt")
	os.system(f"gsettings get org.cinnamon.desktop.background picture-uri > {DIR_HOME}/.local/state/screensaver/bg_restore.txt")

	if os.path.isfile(f"{DIR_HOME}/.local/share/powertoys/lock_blur.jpg"):
		img_age = file_age(f"{DIR_HOME}/.local/share/powertoys/lock_blur.jpg")
	else:
		img_age = -1

	if img_age > 86400 or img_age < 0:
		img_lock  = str(subprocess.check_output("gsettings get x.dm.slick-greeter background | tr -d \"'\"", shell=True)).strip().replace("b'", "").replace("'", "").replace("\\n", "")
		dis_width = int(subprocess.check_output('xdisplayinfo --resolution | cut --delimiter="x" -f 1', shell=True))

		# Blur the lock screen
		img 		= Image.open(img_lock)
		img_height 	= int((float(img.size[1])*float((int(dis_width)/float(img.size[0])))))
		img_gauss 	= img.filter(ImageFilter.GaussianBlur(100))
		img_lock 	= img_gauss.resize((dis_width,img_height))

		img_lock.save(DIR_HOME + '/.local/share/powertoys/lock_blur.jpg')

		time.sleep(5)

	# Swap for the lock screen background
	if os.path.isfile(f"{DIR_HOME}/.local/share/powertoys/lock_blur.jpg"):
		os.system(f"echo 'file://{DIR_HOME}/.local/share/powertoys/lock_blur.jpg' > $HOME/.local/state/screensaver/bg_lock.txt")
	else:
		os.system(f"gsettings get x.dm.slick-greeter background | tr -d \"'\" > $HOME/.local/state/screensaver/bg_lock.txt")

	os.system("gsettings set org.cinnamon.desktop.background picture-uri $(cat $HOME/.local/state/screensaver/bg_lock.txt)")

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
