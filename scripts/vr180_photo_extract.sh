#!/bin/bash

# Feel free to implement amd or nvida hwa
# For INTEL sudo apt install intel-media-va-driver-non-free -- non-free needed to encode


FILE_FULL=$(basename $1)
FILE_NAME=${FILE_FULL%.vr*}
FILE_PATH=$(realpath $1 | sed "s|${FILE_FULL}||g")
FILE_PATH=$(echo "${FILE_PATH}${FILE_NAME}")

FILE_TEMP="${FILE_PATH}/.frames"

mkdir -p "${FILE_TEMP}"
mkdir -p "${FILE_PATH}"

echo "[i] Processing ${FILE_NAME} ..."


ffmpeg -y -hide_banner -loglevel error -i $1 "${FILE_PATH}/${FILE_NAME}_left.jpg"
exiftool -b -ImageData $1 > "${FILE_PATH}/${FILE_NAME}_right.jpg"

ffmpeg -y -hide_banner -loglevel error -i "${FILE_PATH}/${FILE_NAME}_left.jpg" -vf "v360=input=fisheye:output=flat:h_fov=120:v_fov=47.5:pitch=0:roll=0:w=3840:h=2160,crop=w=1920:h=1080,scale=1920:1080,setsar=1" "${FILE_PATH}/${FILE_NAME}_left_flat.jpg"
ffmpeg -y -hide_banner -loglevel error -i "${FILE_PATH}/${FILE_NAME}_right.jpg" -vf "v360=input=fisheye:output=flat:h_fov=120:v_fov=47.5:pitch=0:roll=0:w=3840:h=2160,crop=w=1920:h=1080,scale=1920:1080,setsar=1" "${FILE_PATH}/${FILE_NAME}_right_flat.jpg"

sleep 1

ffmpeg -y -hide_banner -loglevel error -i "${FILE_PATH}/${FILE_NAME}_left_flat.jpg" -i "${FILE_PATH}/${FILE_NAME}_right_flat.jpg" -filter_complex "hstack,stereo3d=sbsl:arcd" "${FILE_PATH}/${FILE_NAME}_anaglyph-cr_dubois.jpg" &
ffmpeg -y -hide_banner -loglevel error -i "${FILE_PATH}/${FILE_NAME}_left_flat.jpg" -i "${FILE_PATH}/${FILE_NAME}_right_flat.jpg" -filter_complex "hstack,stereo3d=sbsl:arch" "${FILE_PATH}/${FILE_NAME}_anaglyph-cr_half.jpg" &
ffmpeg -y -hide_banner -loglevel error -i "${FILE_PATH}/${FILE_NAME}_left_flat.jpg" -i "${FILE_PATH}/${FILE_NAME}_right_flat.jpg" -filter_complex "hstack,stereo3d=sbsl:arch" "${FILE_PATH}/${FILE_NAME}_anaglyph-cr_full.jpg" &
ffmpeg -y -hide_banner -loglevel error -i "${FILE_PATH}/${FILE_NAME}_left_flat.jpg" -i "${FILE_PATH}/${FILE_NAME}_right_flat.jpg" -filter_complex "hstack,stereo3d=sbsl:arcg" "${FILE_PATH}/${FILE_NAME}_anaglyph-cr_bw.jpg" &
ffmpeg -y -hide_banner -loglevel error -i "${FILE_PATH}/${FILE_NAME}_left_flat.jpg" -i "${FILE_PATH}/${FILE_NAME}_right_flat.jpg" -filter_complex "hstack,stereo3d=sbsl:aybd" "${FILE_PATH}/${FILE_NAME}_anaglyph-yb_dubois.jpg" &
ffmpeg -y -hide_banner -loglevel error -i "${FILE_PATH}/${FILE_NAME}_left_flat.jpg" -i "${FILE_PATH}/${FILE_NAME}_right_flat.jpg" -filter_complex "vstack" "${FILE_PATH}/${FILE_NAME}_avb.jpg" &
ffmpeg -y -hide_banner -loglevel error -i "${FILE_PATH}/${FILE_NAME}_left_flat.jpg" -i "${FILE_PATH}/${FILE_NAME}_right_flat.jpg" -filter_complex "hstack" "${FILE_PATH}/${FILE_NAME}_sbs.jpg" &

ffmpeg -y -hide_banner -loglevel error -i "${FILE_PATH}/${FILE_NAME}_left_flat.jpg" -vf "scale=iw/1.5:ih/1.5,crop=w=480:h=640,drawbox=x=470:y=0:w=10:h=640:color=black@1:t=fill" "${FILE_PATH}/${FILE_NAME}_my3d_left.jpg"
ffmpeg -y -hide_banner -loglevel error -i "${FILE_PATH}/${FILE_NAME}_right_flat.jpg" -vf "scale=iw/1.5:ih/1.5,crop=w=480:h=640,drawbox=x=0:y=0:w=10:h=640:color=black@1:t=fill" "${FILE_PATH}/${FILE_NAME}_my3d_right.jpg"
ffmpeg -y -hide_banner -loglevel error -i "${FILE_PATH}/${FILE_NAME}_my3d_left.jpg" -i "${FILE_PATH}/${FILE_NAME}_my3d_right.jpg" -filter_complex "hstack" "${FILE_PATH}/${FILE_NAME}_my3d.jpg" &



touch "${FILE_PATH}/${FILE_NAME}_fliplist.txt"
for (( C=0; C<=2; C+=1 )); do
	echo "file ${FILE_PATH}/${FILE_NAME}_left_flat.jpg" >> "${FILE_PATH}/${FILE_NAME}_fliplist.txt"
done

for (( C=0; C<=2; C+=1 )); do
	echo "file ${FILE_PATH}/${FILE_NAME}_right_flat.jpg" >> "${FILE_PATH}/${FILE_NAME}_fliplist.txt"
done

ffmpeg -y -hide_banner -loglevel error -f concat -safe 0 -i "${FILE_PATH}/${FILE_NAME}_fliplist.txt" -preset slow -filter_complex "loop=loop=20:size=90:start=0" "${FILE_PATH}/${FILE_NAME}_flip.mp4"
rm -f "${FILE_PATH}/${FILE_NAME}_fliplist.txt"



ffmpeg -y -hide_banner -loglevel error -i $1 -vf "v360=input=hequirect:output=flat:h_fov=120:v_fov=120:pitch=-15:roll=10:yaw=20:w=2880:h=1620" "${FILE_PATH}/${FILE_NAME}_pov.jpg" &
ffmpeg -y -hide_banner -loglevel error -i $1 -vf "v360=input=hequirect:fisheye:v_fov=120" "${FILE_PATH}/${FILE_NAME}_square.jpg" &
ffmpeg -y -hide_banner -loglevel error -i $1 -vf "v360=input=fisheye:output=flat:h_fov=120:v_fov=47.5:pitch=0:roll=0,crop=w=3616:h=3016,scale=w=2880:h=2880" "${FILE_PATH}/${FILE_NAME}_circle.jpg" &
ffmpeg -y -hide_banner -loglevel error -i $1 -vf "v360=hequirect:ih_fov=120:iv_fov=120:pitch=0:roll=0:yaw=0:output=perspective,scale=3016:3016" "${FILE_PATH}/${FILE_NAME}_fisheye.jpg" &
ffmpeg -y -hide_banner -loglevel error -i $1 -vf "v360=input=fisheye:output=flat:h_fov=120:v_fov=47.5:pitch=0:roll=0:w=3840:h=2160,crop=w=1920:h=1080,scale=1920:1080,setsar=1" "${FILE_PATH}/${FILE_NAME}_flat.jpg" &

if [ ! -f "${FILE_PATH}/${FILE_NAME}_pan.mp4" ]; then

	for (( C=0; C<=30; C+=1 )); do
		FRAME=$(printf "%02d\n" "${C}")

		if [ ! -f "${FILE_TEMP}/${FILE_NAME}_panright_${FRAME}.jpg" ]; then
			ffmpeg -n -hide_banner -loglevel error -i $1 -vf "v360=input=hequirect:output=flat:h_fov=120:v_fov=120:pitch=0:roll=0:yaw=${C}:w=2880:h=1620" "${FILE_TEMP}/${FILE_NAME}_panright_${FRAME}.jpg"
		fi
		if [ ! -f "${FILE_TEMP}/${FILE_NAME}_panleft_${FRAME}.jpg" ]; then
			ffmpeg -n -hide_banner -loglevel error -i $1 -vf "v360=input=hequirect:output=flat:h_fov=120:v_fov=120:pitch=0:roll=0:yaw=-${C}:w=2880:h=1620" "${FILE_TEMP}/${FILE_NAME}_panleft_${FRAME}.jpg"
		fi
	done


	touch "${FILE_TEMP}/${FILE_NAME}_panlist.txt"

	for (( C=0; C<=30; C+=1 )); do
		FRAME=$(printf "%02d\n" "${C}")
		echo "file '${FILE_NAME}_panleft_${FRAME}.jpg'" >> "${FILE_TEMP}/${FILE_NAME}_panlist.txt"
	done

	for (( C=30; C>=0; C-=1 )); do
        	FRAME=$(printf "%02d\n" "${C}")
        	echo "file '${FILE_NAME}_panleft_${FRAME}.jpg'" >> "${FILE_TEMP}/${FILE_NAME}_panlist.txt"
	done

	for (( C=0; C<=30; C+=1 )); do
        	FRAME=$(printf "%02d\n" "${C}")
        	echo "file '${FILE_NAME}_panright_${FRAME}.jpg'" >> "${FILE_TEMP}/${FILE_NAME}_panlist.txt"
	done

	for (( C=30; C>=0; C-=1 )); do
        	FRAME=$(printf "%02d\n" "${C}")
        	echo "file '${FILE_NAME}_panright_${FRAME}.jpg'" >> "${FILE_TEMP}/${FILE_NAME}_panlist.txt"
	done

	sleep 10

	if [ -f "${FILE_TEMP}/${FILE_NAME}_panlist.txt" ]; then
		ffmpeg -n -hide_banner -loglevel error -f concat -safe 0 -i "${FILE_TEMP}/${FILE_NAME}_panlist.txt" -preset slow -filter_complex "loop=loop=2:size=124:start=0" "${FILE_PATH}/${FILE_NAME}_pan.mp4"
	fi
	rm -f "${FILE_TEMP}/${FILE_NAME}_panlist.txt"
fi
