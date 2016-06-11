#!/bin/sh
# compare debian *SUMS files and result of gpg --print-mds --with-colons
cmp_sum(){
	fn=$1
	sum=$2
	grep -q -w -i "$sum" "${fn}.sums"
}

cmp_file(){
	fn=$1
	for a in *SUMS
	do
		sum=`grep "$fn" $a | awk '{print $1}' | tr '[:lower:]' '[:upper:]'`
		cmp_sum $fn $sum
		if [ $? != 0 ] ; then
			echo "mismatch $a for $fn: $sum"
			return 1
		fi
	done
	return 0
}

files=`find -maxdepth 1 \( -type f -o -type l \) -name "*.iso"`
for a in $files
do
	bn=`basename $a`
	cmp_file $bn
	echo $bn: $?
done
