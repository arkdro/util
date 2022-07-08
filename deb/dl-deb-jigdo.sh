#!/bin/sh

renice -n 18 -p $$
ionice -c 3 -p $$

cur_dir="`dirname "$0"`"
cur_base="`basename "$0"-$$`"
log="${cur_dir}/${cur_base}.log"

default_dist="/opt/debian/7.4.0"
dist=${1:-"$default_dist"}

arch="amd64"
base="debian-11.3.0-${arch}-DVD"
first=1
last=19

for a in `seq $first $last`
	do
		date >> "$log"
		b="$base-$a"
		echo "b: $b" >> "$log"
		jigdo-lite --noask --scan "$dist" "$b.jigdo"
		echo "rc=$?"
		( gpg --print-mds --with-colon $b.iso > $b.iso.sums & )
	done

