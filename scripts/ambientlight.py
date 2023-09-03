#!/usr/bin/env python3

import os, sys, subprocess, time

home = os.path.expanduser('~')

# webcam brightness if webcam doesn’t get any light
blackpoint = 0.05

# webcam brightness if webcam is fully exposed (e.g. sun at noon)
whitepoint = 0.92549

# Path to program that sets screen brightness.  Takes float between 0 and 1 as
# a parameter.  Should be whitelisted for sudo if this script is not run as
# root.  Sample script:
#
# #!/bin/sh
# echo "($1 * 4882) / 1" | bc > /sys/class/backlight/intel_backlight/brightness
brightness_setter = f"{home}/.local/bin/set_brightness.sh"

# it doen’t get any darker
minimal_brightness = 0.1


def get_brightness():
	"""Returns webcam brightness as a float between 0 and 1 (boundaries
	included)."""
	fswebcam = subprocess.Popen(["fswebcam", "-q", "--no-banner", "--png", "0", "-"], stdout=subprocess.PIPE)
	convert = subprocess.run(["convert", "png:-", "-colorspace", "gray", "-scale", "10%x10%", "-format", "%[fx:image.maxima]", "info:"], check=True, stdin=fswebcam.stdout, capture_output=True, text=True)
	assert fswebcam.wait() == 0

	brightness = float(convert.stdout)
	brightness = (brightness - blackpoint) / (whitepoint - blackpoint)
	brightness = max(0.0, min(1.0, brightness))

	return brightness



brightness = get_brightness() ** 2
brightness = max(minimal_brightness, brightness)

print(str(abs(brightness)))
sys.exit()

#if abs(brightness < 0.5):
	#subprocess.run([brightness_setter, str(brightness)], check=True)
