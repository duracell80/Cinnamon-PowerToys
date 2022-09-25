#!/bin/sh -efu

notify-send --urgency=normal --category=transfer --icon=media-record-symbolic "Extracting Video Chapers" "${1}"
ffprobe -print_format csv -show_chapters "$1" | cut -d ',' -f '5,7,8' |

while IFS=, read start end chapter
do
    ffmpeg -nostdin -ss "$start" -to "$end" -i "$1" -c copy -map 0 -map_chapters -1 "${1%.*}-$chapter.${1##*.}"
done
