#!/usr/bin/python3

import os, subprocess, time
from PIL import Image
from PIL import ImageFilter

def file_age(filepath):
	return time.time() - os.path.getmtime(filepath)

def blur_backgrounds():
	# Add commands here to run when screen locks
	DIR_HOME = os.path.expanduser('~')

	dis_width = int(subprocess.check_output('xdisplayinfo --resolution | cut --delimiter="x" -f 1', shell=True))

	# Get current background
	os.system(f"gsettings get org.cinnamon.desktop.background picture-uri > {DIR_HOME}/.local/state/screensaver/bg_restore.txt")
	img_user  = str(subprocess.check_output("gsettings get org.cinnamon.desktop.background picture-uri | tr -d \"'\"", shell=True)).strip().replace("b'", "").replace("'", "").replace("\\n", "").replace("file://", "")
	img_lock  = str(subprocess.check_output("gsettings get x.dm.slick-greeter background | tr -d \"'\"", shell=True)).strip().replace("b'", "").replace("'", "").replace("\\n", "")

	# Blur the lock screen
	img 		= Image.open(img_lock)
	img_height 	= int((float(img.size[1])*float((int(dis_width)/float(img.size[0])))))
	img_gauss 	= img.filter(ImageFilter.GaussianBlur(100))
	img_lock 	= img_gauss.resize((dis_width,img_height))

	img_lock.save(DIR_HOME + '/.local/share/powertoys/lock_blur.jpg')

	time.sleep(3)

	# Blur the current user background
	img             = Image.open(img_user)
	img_height      = int((float(img.size[1])*float((int(dis_width)/float(img.size[0])))))
	img_gauss       = img.filter(ImageFilter.GaussianBlur(100))
	img_user        = img_gauss.resize((dis_width,img_height))

	img_user.save(DIR_HOME + '/.local/share/powertoys/wall_blur.png')
	img_user.save(DIR_HOME + '/.local/share/powertoys/wall_blur.jpg')

if __name__ == "__main__":
	blur_backgrounds()
