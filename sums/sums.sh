#!/bin/sh

one_hash() {
	local hash="$1"
	local file="$2"
	openssl dgst "-${hash}" "$file" |\
		awk -v in_file="$file" -v in_hash="$hash" "{printf(\"%s:%s:%s\n\", in_file, in_hash, \$2)}"
}

one_file() {
	local file="$1"
	size=`stat -c '%s' "$file"`
	echo "$file:0_size:$size"
	while read hash
	do
		one_hash "$hash" "$file" &
	done <<-EOF
		md5
		sha1
		sha256
		sha512
		blake2b512
		sha3-512
	EOF
}

find "$@" -type f |\
	while read f
	do
		one_file "$f"
		wait
	done
