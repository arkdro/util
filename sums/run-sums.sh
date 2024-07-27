#!/bin/sh

# find "$1" -type f -printf '%p:0:%s\n' -exec gpg --print-mds --with-colon '{}' \;

find "$1" -type f |\
	while read f
	do
		size=`stat -c '%s' "${f}"`
		gpg --with-colons --print-md crc32 "${f}" | sed -e "s@:302:[a-f0-9]\+:\$@:0:${size}:@i"
		gpg --with-colons --print-mds "${f}"
	done
