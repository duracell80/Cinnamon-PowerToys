#!/bin/bash
# Take system snapshot and update
# @git:duracell80


# ENVIRONMENT VARS
#DIR_PWD=$(pwd)

sudo /usr/bin/timeshift --create
/usr/bin/mintupdate
