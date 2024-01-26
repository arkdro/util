#!/bin/sh

b=`basename "$0"`
base="${b}-$$-"
ext="mkv"
in="xxxxx-area.$ext"
in_base=`basename "$in" ".$ext"`
out="${in_base}-out"
list="$out-$$.list"

audio_level="-90dB"
video_level="-50dB"
duration="0.2"

#ffmpeg -i "$in" -af silencedetect=noise=$audio_level:d=$duration -f null -
ffmpeg -i "$in" -vf freezedetect=n=$video_level:d=$duration -map 0:v:0 -f null -
