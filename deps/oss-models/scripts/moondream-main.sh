#!/bin/bash

APP="${HOME}/.local/share/oss-models/moondream"
source "${APP}/bin/activate"
START=$(date +%s)

bash -c "${APP}/bin/python3 ${APP}/app/main.py --cpu --image=${1} --prompt='${2}'"

END=$(date +%s)
TOTAL=$(( $END - $START ))

RESPONSE=$(cat "${1}.txt")
IMG_KEYS=$(exiftool -keywords "${1}" | cut -d ":" -f2)
IMG_COMB="Keywords:${IMG_KEYS} Description:${RESPONSE}"

exiftool -overwrite_original -Exif:ImageDescription="${IMG_COMB}" -Exif:XPComment="${IMG_COMB}" -Description="${IMG_COMB}" "${1}"

echo "Running time: ${TOTAL}s \nDescription: ${RESPONSE}"
