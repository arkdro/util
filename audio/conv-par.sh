#!/bin/sh

randomize() {
	local input_dir="$1"
	local randomized_input_dir="$2"
	#find "$input_dir" -type f -iname '*.mp3' -exec cp '{}' "$randomized_input_dir" \;
	find "$input_dir" -type f -iname '*.mp3' -exec touch "$randomized_input_dir"/{} \;

	find "$randomized_input_dir" -type f | shuf |\
	while read a
	do
		d=`dirname "$a"`
		b=`basename "$a"`
		rnd=`dd if=/dev/random bs=1 count=1 | od -A n -t u1 -v  | tr -d ' ' | tr '[:lower:]' '[:upper:]'` 2>/dev/null
		new_b="a$rnd-$b"
		new_a="${d}/${new_b}"
		mv -- "$a" "$new_a"
	done
}

randomize2() {
	local input_dir="$1"
	local randomized_input_dir="$2"
	local counter="$$-cnt"
	echo 1 > "$counter"
	find "$input_dir" -type f -iname '*.mp3' | shuf |\
		while read a
		do
			cnt=`cat "$counter"`
			b=`basename "$a"`
			new_b="a$cnt-$b"
			new_a="${randomized_input_dir}/${new_b}"
			ln -s "$a" "$new_a"
			cnt=$((cnt + 1))
			echo $cnt > "$counter"
		done
	rm -f -- "$counter"

}

conv_one_file() {
	local fin="$1"
	local fout="$2"
	limiter="ladspa=fast_lookahead_limiter_1913:fastLookaheadLimiter:20|-3|0.12"
	param="$limiter"
	# ffmpeg can't handle cover images (see tickets 4448 and 4591),
	# so we map video here to remove them.
	ffmpeg \
		-y \
		-i "$fin" \
		-map 0 -map -0:v \
		-c:a libvorbis \
		-af "$param" \
		"$fout" < /dev/null
# for some files (Apokalypse & Filterkaffee) ecasound does odd things:
# it slows the audio e.g. from 40min to 56min
# (making it sound weird, at a lower frequency)
#		ecasound -i "$fin" -o "$fout" \
#			$compressor \
#			$limiter \
#			$filter
}


conv_one_list() {
	local dir="$1"
	local lst="$2"
	local outdir="$3"
	local lock="${lst}.lock"
	touch "$lock"
	lst_base=`basename "$lst"`
	odir="${dir}/${lst_base}-out"
	mkdir -p "$odir"
	echo "begin, $lst_base: `date`"
	cat "$lst" |\
		while read f
		do
			b=`basename "$f" .mp3`
			out="${b}.ogg"
			fout="${odir}/${out}"
			conv_one_file "$f" "$fout"
			mv "$fout" "$outdir"
		done
	rmdir "$odir"
	rm -f -- "$lock"
	echo "end, $lst_base: `date`"
}

if [ $# -lt 1 ] ; then
	echo parameter needed
	exit 1
fi

if ! [ -d $1 ] ; then
	echo parameter must be a directory
	exit 2
fi

if [ "`basename $1`" = ".." ] ; then
	echo no upper directory allowed
	exit 3
fi

#lst1=`pgrep -f "$0"`
#echo $lst1
#lst2=`pgrep "$0" | grep -v $$`
#echo $lst2
#lst3=`ps xfwww | grep "$0"`
#echo $lst3
#lst4=`ps --ppid $$ | grep ecasound`
#echo $lst4
#
#exit 1

input_dir="$1"
base=`basename "$0"`
basedir=`dirname "$0"`
. $basedir/plugins.rc

nproc=`cat /proc/cpuinfo | grep processor | wc -l | awk '{if($0 < 3) {print 1} else {print $0-2}}'`
prefix="$base-$$-"
total_list="${prefix}lst"

total_out_dir="$input_dir-${prefix}out"
mkdir -p "$total_out_dir"

randomized_input_dir="$input_dir-${prefix}rand"
mkdir -p "$randomized_input_dir"

#randomize "$input_dir" "$randomized_input_dir"
randomize2 "$input_dir" "$randomized_input_dir"

find "$randomized_input_dir" \( -type f -o -type l \) -iname '*.mp3' > "$total_list"
split -d -nl/$nproc "$total_list" "$prefix"
locks="${prefix}[0-9]*.lock"
find . -type f -name "${prefix}[0-9]*" |\
	while read lst
	do
		(
		conv_one_list "$randomized_input_dir" $lst "$total_out_dir"
		rm -f -- "$lst"
		) &
	done
rm -f -- "$total_list"

sleep 5
while(true)
do
	nums=`find -maxdepth 1 -type f -name "$locks" | wc -l`
	if [ "$nums" = "0" ] ; then
		echo no locks, exiting
		break
	fi
	#ps xfwww | grep -vw grep | grep -A10000 "^ *$$" | grep -q ecasound || break
	sleep 5
done
