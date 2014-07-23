#!/bin/sh

set -eu

run(){
	echo -n `date '+%Y-%m-%d %H:%M:%S'`
	echo -n ' '

	h=192.168.1.1
	echo `ping -w 40 -q -n $h | grep rtt | cut -d '=' -f 2 | cut -d '/' -f 2`
}

b=`basename "$0"`
LOCK=/tmp/$b-$LOGNAME.lck
test -e $LOCK && exit 0

touch $LOCK
acc=${1:-"$HOME/${b}.log"}
run >> "$acc"
rm -f -- $LOCK
