#!/bin/bash

APP="${HOME}/.local/share/oss-models/moondream"
source "${APP}/bin/activate"
START=$(date +%s)

bash -c "${APP}/bin/python3 ${APP}/app/main.py --cpu --image=${1} --prompt='${2}'"

END=$(date +%s)
TOTAL=$(( $END - $START ))

RESPONSE=$(cat "${1}.txt")
exiftool -overwrite_original -Exif:ImageDescription="${RESPONSE}" -Description="${RESPONSE}" "${1}"

echo "Running time: ${TOTAL}s"
exit
