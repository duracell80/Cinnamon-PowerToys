#!/bin/bash

APP="${HOME}/.local/share/oss-models/moondream"
source "${APP}/bin/activate"
bash -c "${APP}/bin/python3 ${APP}/app/main.py --cpu --image=${1} --prompt='${2}'"
exit
