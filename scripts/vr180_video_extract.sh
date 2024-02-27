#!/bin/bash

# http://trac.ffmpeg.org/wiki/Stereoscopic

INFO_RAM=$(awk '/^MemTotal:/{print $2}' /proc/meminfo)
CONF_FIL="v360=dfisheye:hequirect:output=flat:in_stereo=sbs:out_stereo=sbs:ih_fov=60:iv_fov=60:pitch=0:roll=0:yaw=-28"
CONF_SCL="scale=3840:2160"


FILE_FULL=$(basename $1)
FILE_NAME=${FILE_FULL%.vr*}
FILE_PATH=$(realpath $1 | sed "s|${FILE_FULL}||g")
FILE_PATH=$(echo "${FILE_PATH}${FILE_NAME}")

FILE_TEMP="${FILE_PATH}/.frames"
FILE_META="${FILE_PATH}/.meta"

mkdir -p "${FILE_TEMP}"
mkdir -p "${FILE_META}"

ffprobe -v error -hide_banner -of default=noprint_wrappers=0 -print_format json -show_format -show_streams $1 > "${FILE_META}/${FILE_NAME}_meta.json"


if [[ $INFO_RAM > 19000000 ]]; then
        ffmpeg -y -hide_banner -loglevel error -i $1 -vf "${CONF_FIL},stereo3d=sbsl:ml,${CONF_SCL}" -preset fast "${FILE_META}/${FILE_NAME}_left.mp4"
        ffmpeg -y -hide_banner -loglevel error -i $1 -vf "${CONF_FIL},stereo3d=sbsr:mr,${CONF_SCL}" -preset fast "${FILE_META}/${FILE_NAME}_right.mp4"
        ffmpeg -y -hide_banner -loglevel error -i $1 -b:a 192K -vn "${FILE_META}/${FILE_NAME}_audio.mp3" &

        ffmpeg -y -hide_banner -loglevel error -i $1 -vf "eq=brightness=0.05:saturation=1.5,${CONF_FIL},stereo3d=sbs2l:arcd,${CONF_SCL}" -preset fast "${FILE_PATH}/${FILE_NAME}_anaglyph-cr_dubois.mp4" &
        ffmpeg -y -hide_banner -loglevel error -i $1 -vf "eq=brightness=0.05:contrast=0.5,${CONF_FIL},stereo3d=sbs2l:arcg,${CONF_SCL}" -preset fast "${FILE_PATH}/${FILE_NAME}_anaglyph-cr_bw.mp4" &
        ffmpeg -y -hide_banner -loglevel error -i "${FILE_META}/${FILE_NAME}_left.mp4" -i "${FILE_META}/${FILE_NAME}_right.mp4" -filter_complex "hstack" -preset fast "${FILE_META}/${FILE_NAME}_sbs_full.mp4"
        ffmpeg -y -hide_banner -loglevel error -i "${FILE_META}/${FILE_NAME}_sbs_full.mp4" -filter_complex "scale=1920:1080" -c:a copy "${FILE_PATH}/${FILE_NAME}-sbs_1080s.mp4" &
	ffmpeg -y -hide_banner -loglevel error -i $1 -vf "eq=brightness=0.05:contrast=0.5,${CONF_FIL},stereo3d=sbs2l:icl,${CONF_SCL}" -preset fast "${FILE_PATH}/${FILE_NAME}_interleaved-col_lf.mp4" &
	ffmpeg -y -hide_banner -loglevel error -i $1 -vf "eq=brightness=0.05:contrast=0.5,${CONF_FIL},stereo3d=sbs2l:irl,${CONF_SCL}" -preset fast "${FILE_PATH}/${FILE_NAME}_interleaved-row_lf.mp4"

else
        ffmpeg -n -hide_banner -loglevel error -i $1 -vf "${CONF_FIL},stereo3d=sbsl:ml,${CONF_SCL}" -preset fast "${FILE_META}/${FILE_NAME}_left.mp4"
        ffmpeg -n -hide_banner -loglevel error -i $1 -vf "${CONF_FIL},stereo3d=sbsr:mr,${CONF_SCL}" -preset fast "${FILE_META}/${FILE_NAME}_right.mp4"
        ffmpeg -y -hide_banner -loglevel error -i $1 -b:a 192K -vn "${FILE_META}/${FILE_NAME}_audio.mp3"

        ffmpeg -y -hide_banner -loglevel error -i $1 -vf "eq=brightness=0.05:saturation=1.5,${CONF_FIL},stereo3d=sbs2l:arcd,${CONF_SCL}" -preset veryfast "${FILE_PATH}/${FILE_NAME}_anaglyph-cr_dubois.mp4"
        ffmpeg -n -hide_banner -loglevel error -i $1 -vf "eq=brightness=0.05:contrast=0.5,${CONF_FIL},stereo3d=sbs2l:arcg,${CONF_SCL}" "${FILE_PATH}/${FILE_NAME}_anaglyph-cr_bw.mp4"
        ffmpeg -y -hide_banner -loglevel error -i "${FILE_META}/${FILE_NAME}_left.mp4" -i "${FILE_META}/${FILE_NAME}_right.mp4" -filter_complex "hstack" -preset veryfast "${FILE_META}/${FILE_NAME}_sbs_full.mp4"
        ffmpeg -y -hide_banner -loglevel error -i "${FILE_META}/${FILE_NAME}_sbs_full.mp4" -filter_complex "scale=1920:1080" -c:a copy "${FILE_PATH}/${FILE_NAME}-sbs_1080s.mp4"
	ffmpeg -y -hide_banner -loglevel error -i $1 -vf "eq=brightness=0.05:contrast=0.5,${CONF_FIL},stereo3d=sbs2l:icl,${CONF_SCL}" -preset fast "${FILE_PATH}/${FILE_NAME}_interleaved-col_lf.mp4"
        ffmpeg -y -hide_banner -loglevel error -i $1 -vf "eq=brightness=0.05:contrast=0.5,${CONF_FIL},stereo3d=sbs2l:irl,${CONF_SCL}" -preset fast "${FILE_PATH}/${FILE_NAME}_interleaved-row_lf.mp4"
fi

cp -n "${FILE_META}/${FILE_NAME}_left.mp4" "${FILE_PATH}/${FILE_NAME}_flat.mp4"
