#!/bin/sh
if [ $# -lt 1 ] ; then
	echo 'need parameter'
	exit 1
fi
file="$1"
erl -pa ebin -noinput -noshell -s trace_conv conv_part -f "$file"
