#!/bin/bash

# Feel free to implement amd or nvida hwa
# sudo apt install intel-media-va-driver-non-free -- non-free needed to encode

GPU_INTEL=$(ffmpeg -hide_banner -loglevel error -encoders | grep h264_qsv | wc -l)
GPU_DRIVR=$(ffmpeg -hide_banner -loglevel error -h encoder=h264_qsv | grep -i "Supported hardware devices: qsv qsv qsv" | wc -l)
GPU_INUSE=0

mkdir -p .meta

ffmpeg -y -hide_banner -loglevel error -i $1 -vf "v360=input=hequirect:output=flat:h_fov=120:v_fov=120:pitch=-15:roll=10:yaw=20:w=2880:h=1620" $1_pov.jpg &
ffmpeg -y -hide_banner -loglevel error -i $1 -vf "v360=input=hequirect:fisheye:v_fov=120" $1_square.jpg &
ffmpeg -y -hide_banner -loglevel error -i $1 -vf "v360=input=fisheye:output=flat:h_fov=120:v_fov=47.5:pitch=0:roll=0,crop=w=3616:h=3016,scale=w=2880:h=2880" $1_circle.jpg &
ffmpeg -y -hide_banner -loglevel error -i $1 -vf "v360=input=fisheye:output=flat:h_fov=120:v_fov=47.5:pitch=0:roll=0:w=3840:h=2160,crop=w=1920:h=1080,scale=1920:1080,setsar=1" $1_flat.jpg &

for (( C=0; C<=30; C+=1 )); do
	FRAME=$(printf "%02d\n" "${C}")

	ffmpeg -n -hide_banner -loglevel error -i $1 -vf "v360=input=hequirect:output=flat:h_fov=120:v_fov=120:pitch=0:roll=0:yaw=${C}:w=2880:h=1620" ".meta/${1}_panright_${FRAME}.jpg" &
	ffmpeg -n -hide_banner -loglevel error -i $1 -vf "v360=input=hequirect:output=flat:h_fov=120:v_fov=120:pitch=0:roll=0:yaw=-${C}:w=2880:h=1620" ".meta/${1}_panleft_${FRAME}.jpg"
done

rm -f test_panlist.txt

ls --format=single-column .meta/$1_panleft* >> $1_panlist.txt
ls --format=single-column .meta/$1_panleft* | sort -r >> $1_panlist.txt

ls --format=single-column .meta/$1_panright* >> $1_panlist.txt
ls --format=single-column .meta/$1_panright* | sort -r >> $1_panlist.txt

sed -i 's/^/file /' $1_panlist.txt

if [[ $GPU_INUSE == 1 ]]; then
	ffmpeg -y -hide_banner -loglevel error -f concat -safe 0 -i $1_panlist.txt -vcodec h264_qsv -preset veryslow -filter_complex "loop=loop=2:size=124:start=0" $1_pan.mp4
else
	ffmpeg -y -hide_banner -loglevel error -f concat -safe 0 -i $1_panlist.txt -preset veryslow -filter_complex "loop=loop=2:size=124:start=0" $1_pan.mp4
fi

rm -f $1_panlist.txt

#rm .meta/test_panleft*
#rm .meta/test_panright*
