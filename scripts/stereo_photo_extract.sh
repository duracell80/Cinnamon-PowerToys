#!/bin/bash

# Feel free to implement amd or nvida hwa
# For INTEL sudo apt install intel-media-va-driver-non-free -- non-free needed to encode


FILE_FULL=$(basename $1)
FILE_NAME=${FILE_FULL%.*}
FILE_PATH=$(realpath $1 | sed "s|${FILE_FULL}||g")
FILE_PATH=$(echo "${FILE_PATH}${FILE_NAME}")

FILE_TEMP="${FILE_PATH}/.frames"

mkdir -p "${FILE_TEMP}"

echo "[i] Processing ${FILE_NAME} ..."


CONF_CORR="0"

ffmpeg -y -hide_banner -loglevel error -i $1 -vf "crop=x=${CONF_CORR}:y=0:w=iw/2:h=ih" "${FILE_TEMP}/${FILE_NAME}_left_temp.jpg"
ffmpeg -y -hide_banner -loglevel error -i $1 -vf "crop=x=iw/2:y=0:w=iw/2:h=ih" "${FILE_TEMP}/${FILE_NAME}_right_temp.jpg"

ffmpeg -y -hide_banner -loglevel error -i "${FILE_TEMP}/${FILE_NAME}_left_temp.jpg" -vf "crop=x=0:y=0:w=iw-${CONF_CORR}:h=ih" "${FILE_TEMP}/${FILE_NAME}_left.jpg"
ffmpeg -y -hide_banner -loglevel error -i "${FILE_TEMP}/${FILE_NAME}_right_temp.jpg" -vf "crop=x=0:y=0:w=iw-${CONF_CORR}:h=ih" "${FILE_TEMP}/${FILE_NAME}_right.jpg"



ffmpeg -y -hide_banner -loglevel error -i "${FILE_TEMP}/${FILE_NAME}_left.jpg" -vf "crop=x=iw/12:y=ih/12:w=3840/1.05:h=2160/1.05" "${FILE_TEMP}/${FILE_NAME}_left-16x9.jpg"
ffmpeg -y -hide_banner -loglevel error -i "${FILE_TEMP}/${FILE_NAME}_right.jpg" -vf "crop=x=iw/12:y=ih/12:w=3840/1.05:h=2160/1.05" "${FILE_TEMP}/${FILE_NAME}_right-16x9.jpg"



ffmpeg -y -hide_banner -loglevel error -i "${FILE_TEMP}/${FILE_NAME}_left.jpg" -i "${FILE_TEMP}/${FILE_NAME}_right.jpg" -filter_complex "hstack,stereo3d=sbsl:arcd" "${FILE_PATH}/${FILE_NAME}_anaglyph-cr_dubois.jpg"



ffmpeg -y -hide_banner -loglevel error -i "${FILE_TEMP}/${FILE_NAME}_left.jpg" -i "${FILE_TEMP}/${FILE_NAME}_right.jpg" -filter_complex "hstack,stereo3d=sbsl:arch" "${FILE_PATH}/${FILE_NAME}_anaglyph-cr_half.jpg"
ffmpeg -y -hide_banner -loglevel error -i "${FILE_TEMP}/${FILE_NAME}_left.jpg" -i "${FILE_TEMP}/${FILE_NAME}_right.jpg" -filter_complex "hstack,stereo3d=sbsl:arcc" "${FILE_PATH}/${FILE_NAME}_anaglyph-cr_full.jpg"
ffmpeg -y -hide_banner -loglevel error -i "${FILE_TEMP}/${FILE_NAME}_left.jpg" -i "${FILE_TEMP}/${FILE_NAME}_right.jpg" -filter_complex "hstack,stereo3d=sbsl:arcg" "${FILE_PATH}/${FILE_NAME}_anaglyph-cr_bw.jpg"
ffmpeg -y -hide_banner -loglevel error -i "${FILE_TEMP}/${FILE_NAME}_left.jpg" -i "${FILE_TEMP}/${FILE_NAME}_right.jpg" -filter_complex "hstack,stereo3d=sbsl:aybd" "${FILE_PATH}/${FILE_NAME}_anaglyph-yb_dubois.jpg"


ffmpeg -y -hide_banner -loglevel error -i "${FILE_TEMP}/${FILE_NAME}_left-16x9.jpg" -i "${FILE_TEMP}/${FILE_NAME}_right-16x9.jpg" -filter_complex "hstack,stereo3d=sbsl:arcd" "${FILE_PATH}/${FILE_NAME}-16x9_anaglyph-cr_dubois.jpg"
ffmpeg -y -hide_banner -loglevel error -i "${FILE_TEMP}/${FILE_NAME}_left-16x9.jpg" -i "${FILE_TEMP}/${FILE_NAME}_right-16x9.jpg" -filter_complex "hstack,stereo3d=sbsl:arch" "${FILE_PATH}/${FILE_NAME}-16x9_anaglyph-cr_half.jpg"
ffmpeg -y -hide_banner -loglevel error -i "${FILE_TEMP}/${FILE_NAME}_left-16x9.jpg" -i "${FILE_TEMP}/${FILE_NAME}_right-16x9.jpg" -filter_complex "hstack,stereo3d=sbsl:arcc" "${FILE_PATH}/${FILE_NAME}-16x9_anaglyph-cr_full.jpg"
ffmpeg -y -hide_banner -loglevel error -i "${FILE_TEMP}/${FILE_NAME}_left-16x9.jpg" -i "${FILE_TEMP}/${FILE_NAME}_right-16x9.jpg" -filter_complex "hstack,stereo3d=sbsl:arcg" "${FILE_PATH}/${FILE_NAME}-16x9_anaglyph-cr_bw.jpg"
ffmpeg -y -hide_banner -loglevel error -i "${FILE_TEMP}/${FILE_NAME}_left-16x9.jpg" -i "${FILE_TEMP}/${FILE_NAME}_right-16x9.jpg" -filter_complex "hstack,stereo3d=sbsl:aybd" "${FILE_PATH}/${FILE_NAME}-16x9_anaglyph-yb_dubois.jpg"



ffmpeg -y -hide_banner -loglevel error -i "${FILE_TEMP}/${FILE_NAME}_left.jpg" -vf "scale=iw/4:ih/4,crop=w=480:h=640,drawbox=x=470:y=0:w=15:h=640:color=black@1:t=fill" "${FILE_TEMP}/${FILE_NAME}_my3d_left.jpg"
ffmpeg -y -hide_banner -loglevel error -i "${FILE_TEMP}/${FILE_NAME}_right.jpg" -vf "scale=iw/4:ih/4,crop=w=480:h=640,drawbox=x=0:y=0:w=15:h=640:color=black@1:t=fill" "${FILE_TEMP}/${FILE_NAME}_my3d_right.jpg"
ffmpeg -y -hide_banner -loglevel error -i "${FILE_TEMP}/${FILE_NAME}_my3d_left.jpg" -i "${FILE_TEMP}/${FILE_NAME}_my3d_right.jpg" -filter_complex "hstack" "${FILE_PATH}/${FILE_NAME}_my3d.jpg"
