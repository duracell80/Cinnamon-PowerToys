#!/bin/bash

# http://trac.ffmpeg.org/wiki/Stereoscopic

INFO_RAM=$(awk '/^MemTotal:/{print $2}' /proc/meminfo)
CONF_FIL="v360=dfisheye:hequirect:output=flat:in_stereo=sbs:out_stereo=sbs:ih_fov=60:iv_fov=60:pitch=0:roll=0:yaw=-28"
CONF_SCL="scale=3840:2160"

if [[ $INFO_RAM > 19000000 ]]; then
	ffmpeg -y -i $1 -vf "${CONF_FIL},stereo3d=sbsl:ml,${CONF_SCL}" -preset fast $1_left.mp4 &
	ffmpeg -y -i $1 -vf "${CONF_FIL},stereo3d=sbsr:mr,${CONF_SCL}" -preset fast $1_right.mp4
	ffmpeg -y -i $1 -b:a 192K -vn $1_audio.mp3 &

	ffmpeg -y -i $1 -vf "eq=brightness=0.05:saturation=1.5,${CONF_FIL},stereo3d=sbs2l:arcc,${CONF_SCL}" $1_anaglyph.mp4 &
	ffmpeg -y -i $1 -vf "eq=brightness=0.05:contrast=0.5,${CONF_FIL},stereo3d=sbs2l:arcg,${CONF_SCL}" $1_anaglyph_bw.mp4
else
	ffmpeg -n -i $1 -vf "${CONF_FIL},stereo3d=sbsl:ml,${CONF_SCL}" -preset fast $1_left.mp4
        ffmpeg -n -i $1 -vf "${CONF_FIL},stereo3d=sbsr:mr,${CONF_SCL}" -preset fast $1_right.mp4
        ffmpeg -y -i $1 -b:a 192K -vn $1_audio.mp3

        ffmpeg -n -i $1 -vf "eq=brightness=0.05:saturation=1.5,${CONF_FIL},stereo3d=sbs2l:arcc,${CONF_SCL}" $1_anaglyph.mp4
        ffmpeg -n -i $1 -vf "eq=brightness=0.05:contrast=0.5,${CONF_FIL},stereo3d=sbs2l:arcg,${CONF_SCL}" $1_anaglyph_bw.mp4
fi
