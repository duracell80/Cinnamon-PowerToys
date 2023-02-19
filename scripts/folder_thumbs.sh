#!/bin/bash
# GENERATE THUMBNAILS AS EMBLEMS FOR FOLDERS

DIR_PICT=$HOME/Pictures
DIR_VIDS=$HOME/Videos
DIR_THUM=$HOME/.icons/DermoDeX/scalable/emblems
FILE_EXT=""
mkdir -p $DIR_THUM



do_pictures () {
	
	if [ `ls -1 $1/*.png 2>/dev/null | wc -l` != 0 ]; then 
	    FILE_EXT+=" $1/*.png"
	fi 
	if [ `ls -1 $1/*.jpg 2>/dev/null | wc -l` != 0 ]; then 
	    FILE_EXT+=" $1/*.jpg"
	fi
	if [ `ls -1 $1/*.jpeg 2>/dev/null | wc -l` != 0 ]; then 
	    FILE_EXT+=" $1/*.jpeg"
	fi

	if [[ "$FILE_EXT" == *"jpg"* || "$FILE_EXT" == *"jpeg"* || "$FILE_EXT" == *"png"* ]]; then
	    FILE_NUM=$(ls $FILE_EXT | wc -l)
	    FILE_CAT=$(ls -Q $FILE_EXT | shuf -n 4); eval "arr=($FILE_CAT)"

	    if [[ "${#arr[@]}" -gt "3" ]]; then
        
        UUID_PIC=$(uuidgen)
	    touch $DIR_THUM/thumb-$UUID_PIC.png
        
        
		montage \
		-mode concatenate \
		-crop 1000x1000+0+0 \
		-geometry 60x60+2+2 \
		-tile 2x2 \
		"${arr[0]}" "${arr[1]}" "${arr[2]}" "${arr[3]}" \
		$DIR_THUM/thumb-$UUID_PIC.png
	    
		gio set -t stringv $1 metadata::emblems "thumb-$UUID_PIC"
	    
	    fi  
	    
	fi
}

rm -f $DIR_THUM/*.png
for dir in $DIR_PICT/*; do (do_pictures "$dir"); done