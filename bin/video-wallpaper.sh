#!/usr/bin/env bash
# author: Tolga MALKOC | ghostlexly@gmail.com
# contributor: SwallowYourDreams | https://github.com/SwallowYourDreams
# contributor: duracell80 | https://github.com/duracell80

# Global variables
name="video-wallpaper"
scriptdir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
confdir="/home/$USER/.config/video-wallpaper"
conf="$confdir/settings.conf"
if [ ! -d "$confdir" ] ; then
	mkdir "$confdir"
	touch "$conf"	
fi

# Read config
read_config() {
	if [ -f "$conf" ] ; then
		source "$conf" &> /dev/null # To do: Find a more elegant way of reading variables from the config file. The shell will throw an error because it stumbles over the [video-wallpaper settings] section. For now, this is tolerable; the error message will be sent to /dev/null.
	else
		echo 'pid=""' > "$conf"
		echo 'lastfile=""' >> "$conf"
	fi
}
read_config

# Write to config file
# Parameters: $1: pid | $2: Video file
update_config() {
	echo "[$name settings]" > "$conf"
	if [ ${#1} -gt 0 ] ; then
		pid=$1
	else
		pid=""
	fi
	if [ ${#2} -gt 0 ] ; then
		lastfile="$2"
	fi
	echo "pid=$pid" >> "$conf"
	echo "lastfile=$lastfile" >> "$conf"
}

# Start video wallpaper playback
start() {
	# If there is an active video wallpaper, stop it first.
	if [ ${#pid} -gt 0 ] ; then
		stop
	fi
	VIDEO_PATH="$1"
	SCREENS=`xrandr | grep " connected\|\*" | pcregrep -o1 '([0-9]{1,}[x]{1,1}[0-9+]{1,}) \('`
	for item in $SCREENS
	do
		"$scriptdir"/xwinwrap -g $item -fdt -ni -b -nf -un -o 1.0 -- mpv -wid WID --loop --no-audio --input-ipc-server=/tmp/gpuwallpaper.socket "$VIDEO_PATH" & disown
	done
	update_config $! "\"$VIDEO_PATH\""
}

stop() {
	if [ ${#pid} -gt 0 ] ; then
		echo "Stopping $name."
		kill "$pid"
	else
		echo "No active video wallpaper found."
	fi
	update_config "" "\"$lastfile\""
}

pause() {
    echo '{ "command": ["set_property", "pause", true] }' | socat - /tmp/gpuwallpaper.socket
}

play() {
    echo '{ "command": ["set_property", "pause", false] }' | socat - /tmp/gpuwallpaper.socket
}

# Start / disable playback of video file on system startup.
# Parameters: $2 = true|false $3 = videofile
startup() {
	startup=""
	if [ "$2" == "true" ] ; then
		echo "Enabling startup of video wallpaper."
		startup="true"
		videofile="$3"
	elif [ "$2" == "false" ] ; then
		echo "Disabling startup of video wallpaper."
		startup="false"
		videofile="$lastfile"
	else
		echo "Illegal startup parameter."
		exit 1
	fi
	LAUNCH_SCRIPT="bash -c '\"$scriptdir/$name.sh\" --start \"$videofile\"'"
	printf "[Desktop Entry]\nType=Application\nExec=$LAUNCH_SCRIPT\nHidden=false\nNoDisplay=false\nX-GNOME-Autostart-enabled=$startup\nName=$name" > "/home/$USER/.config/autostart/$name.desktop"
}

# Checks if a (video) file exists. Displays and error and stops the script if it doesn't
# $1 = the file to be checked
file_exists() {
	if [ ! -f "$1" ] ; then
		echo "Error. File does not exist: $1"
		exit 1
	fi
}

# get arguments
print_help() {
    echo "Usage: ./$name.sh [--start] [--stop] [--startup true|false] \"video_path.mp4\""
    echo ""
    echo "--start Start playback of video file."
    echo "--stop Stop active playback."
    echo "--pause Pause active playback."
    echo "--play Resume active playback."
    echo "--startup Start/disable playback of video file on system startup."
    echo ""
}

# If missing parameters, show help
if [ $# = 0 ]
    then print_help
        exit 1
fi

# Parse parameters
while true
    do if [ $# -gt 0 ]
        then case $1 in
            --startup*)
				file_exists "$3"
                startup "${@}"
                exit 0
            ;;
            
			--start*)
				if [ ${#2} -gt 0 ]; then
					file_exists "$2"
					start "$2"
				else
					print_help
					exit 1
				fi
				exit 0
			;;
			
            --stop*)
				stop
				exit 2
            ;;
            
            --pause*)
				pause
                exit 0
            ;;
            
            --play*)
				play
                exit 0
            ;;
            

            --*)
                print_help
                exit 1
            ;;

            *)
                break
            ;;
        esac
    else
        echo "No video path given!"
        exit 2
    fi
done
