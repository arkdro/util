#!/bin/sh

# put a black rectangle
# Does re-encoding

b=`basename "$0"`
base="${b}-$$-"
ext="mkv"
in="xxxxx.$ext"
in_base=`basename "$in" ".$ext"`
out="${in_base}-out"

#dur="-t 40"
#color="pink@0.5"
color="black"
coord="x=900:y=500:w=100:h=100"
vf_params="drawbox=${coord}:color=${color}:t=fill"

#color="black"
#coord="x=50:y=50:w=50:h=50"
#vf_params="drawbox=${coord}:color=${color}"

ffmpeg \
	-y \
	-i "$in" \
	-c:a copy \
	-vf "$vf_params" \
	$dur \
	"$out.$ext"

