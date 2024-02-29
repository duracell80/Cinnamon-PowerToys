#!/bin/bash

# http://trac.ffmpeg.org/wiki/Stereoscopic
# https://radiona.org/wiki/project/stereoscopy
# FOR: KANDAO QOOCAM EGO 2023 3D VIDEO
# LR Eye alignment needed for this camera

INFO_RAM=$(awk '/^MemTotal:/{print $2}' /proc/meminfo)
CONF_VRB="-loglevel error -hide_banner"
CONF_SCL="scale=1920:1080"

FILE_FULL=$(basename $1)
FILE_NAME=${FILE_FULL%.*}
FILE_PATH=$(realpath $1 | sed "s|${FILE_FULL}||g")
FILE_PATH=$(echo "${FILE_PATH}${FILE_NAME}")

FILE_TEMP="${FILE_PATH}/.frames"
FILE_META="${FILE_PATH}/.meta"


mkdir -p "${FILE_TEMP}"
mkdir -p "${FILE_META}"

ffprobe $CONF_VRB -of default=noprint_wrappers=0 -print_format json -show_format -show_streams $1 > "${FILE_META}/${FILE_NAME}_meta.json"


ffmpeg -n $CONF_VRB -i $1 -b:a 192K -vn "${FILE_META}/${FILE_NAME}_audio.mp3" &
ffmpeg -y $CONF_VRB -i $1 -vf "stereo3d=sbsr:mr,${CONF_SCL}" -preset fast "${FILE_META}/${FILE_NAME}_right.mp4"
ffmpeg -y $CONF_VRB -i $1 -vf "eq=brightness=0.05:saturation=0.5,stereo3d=sbsl:arcd,${CONF_SCL}" -preset fast "${FILE_PATH}/${FILE_NAME}_anaglyph-cr_dubois.mp4"
ffmpeg -n $CONF_VRB -i $1 -vf "eq=brightness=0.5:contrast=0.5,stereo3d=sbsl:arcg,${CONF_SCL}" -preset fast "${FILE_PATH}/${FILE_NAME}_anaglyph-cr_bw.mp4"


ffmpeg -n $CONF_VRB -i "${FILE_META}/${FILE_NAME}_right.mp4" -vf "thumbnail=300,setpts=N/TB" -r 1 -vframes 50 "${FILE_TEMP}/${FILE_NAME}_f%03d.jpg" &
ffmpeg -n $CONF_VRB -i "${FILE_META}/${FILE_NAME}_right.mp4" -vf "scale=1920:1080,thumbnail=300,setpts=N/TB" -r 1 -vframes 50 "${FILE_TEMP}/${FILE_NAME}_1080-f%03d.jpg"
ffmpeg -n $CONF_VRB -i "${FILE_META}/${FILE_NAME}_right.mp4" -vf "scale=iw/2:ih/2,crop=640:480,thumbnail=300,setpts=N/TB" -r 1 -vframes 50 "${FILE_TEMP}/${FILE_NAME}_480-f%03d.jpg"
ffmpeg -n $CONF_VRB -i "${FILE_META}/${FILE_NAME}_right.mp4" -vf "crop=800:800,scale=800:800,thumbnail=300,setpts=N/TB" -r 1 -vframes 50 "${FILE_TEMP}/${FILE_NAME}_800-f%03d.jpg"


mv "${FILE_META}/${FILE_NAME}_right.mp4" "${FILE_PATH}/${FILE_NAME}_flat.mp4"
