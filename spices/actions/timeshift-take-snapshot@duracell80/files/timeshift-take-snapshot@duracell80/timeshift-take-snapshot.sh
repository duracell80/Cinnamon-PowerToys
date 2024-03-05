#!/bin/bash
# Take system snapshot and update
# @git:duracell80


# ENVIRONMENT VARS
#DIR_PWD=$(pwd)

if [ -z "$(groups ${USER} | grep sudo)" ]; then
	zenity --error --icon-name=security-high-symbolic --text="Permission to run sudo needed (run usermod -aG sudo ${USER})"
	exit
fi

SESAME=`zenity --password \
		--icon-name=security-high-symbolic \
		--width=500 \
		--title="Sudo needed (Timeshift)"`


if [[ -z "$SESAME" ]];then
	zenity --error --icon-name=security-high-symbolic --text="Authentication not completed, exiting.";
	exit
else
	notify-send --urgency=normal \
                --icon=computer-symbolic \
                "System Snapshot (Started)" \
                "Timeshift system snapshot is being created. The update manager will follow shortly!"


	sudo -S <<< $SESAME timeshift --create --comments "Before Update"

	notify-send --urgency=normal \
	--icon=computer-symbolic "System Snapshots (Completed)" "Snapshot complete, use this to roll back the next updates applied in the update manager."

	sudo -S <<< $SESAME timeshift-gtk &
	mintupdate &
fi
