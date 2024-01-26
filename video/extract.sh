#!/bin/bash

# extract several fragments from a video file and write them into another video file

one() {
	local idx="$1"
	local ss="$2"
	local to="$3"
	output="$out-$idx.$ext"
	names[$idx]="$output"
	ffmpeg \
		-y \
		-i "$in" \
		$ss \
		$to \
		-c copy \
		"$out-$idx.$ext"
}

join() {
	ffmpeg \
		-y \
		-f concat \
		-i "$list" \
		-c copy \
		"$out-all.$ext"
}

build_list() {
	(
	for f in ${names[@]}
	do
		echo "file $f"
	done
	) > "$list"
}

cleanup() {
	for f in ${names[@]}
	do
		rm -f -- "$f"
	done
	rm -f -- "$list"
}

b=`basename "$0"`
base="${b}-$$-"
ext="mkv"
in="xxxxxx.$ext"
in_base=`basename "$in" ".$ext"`
out="${in_base}-out"
list="$out-$$.list"

declare names

one 1 "-ss 0:00:11" "-to 0:07:11"
one 2 "-ss 0:08:44.5" "-to 0:15:45"
one 3 "-ss 0:17:21" "-to 0:24:19"
one 4 "-ss 0:25:54.5" "-to 0:28:35.5"

echo "all names:"
echo "${names[@]}"

build_list
join
cleanup
