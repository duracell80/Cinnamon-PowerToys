#! /bin/bash
mkdir -p ./ogg
for file in *.oga; do
    filebasename=`basename "$file" .ogg`
    fileout="./ogg/${filebasename/.oga/""}.ogg"

    ffmpeg -i "$file" -acodec libvorbis -ab 32k -ab 64k -ar 44100 "$fileout"
done
