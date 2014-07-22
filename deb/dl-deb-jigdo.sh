#!/bin/sh

default_dist="/opt/debian/7.4.0"
dist=${1:-"$default_dist"}

for a in *.jigdo
do
	jigdo-lite --noask --scan "$dist" $a
done

for a in *.jigdo
do
	b=`basename $a .jigdo`
	echo $b
	fn="${b}.iso"
	gpg --print-mds --with-colons "$fn" > "${fn}.sums"
done
