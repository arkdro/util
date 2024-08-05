#!/bin/bash

# use temp directory to run firefox

set -euo pipefail
IFS=$'\n\t'

renice -n 18 -p $$
ionice -c 3 -p $$

base="${TMP:-$HOME/tmp}"
tmpdir="${base}/i"
mkdir -p "$tmpdir"
new_tmp=`mktemp -d --tmpdir="$tmpdir" "tmp.XXXXXXXXXX"`

export TMP=$new_tmp
export TEMP=$TMP
export TMPDIR=$TMP
export TEMPDIR=$TMP

dir=`mktemp -d --tmpdir="$new_tmp" "bf.XXXXXXXXXX"`
echo "dir: $dir"

mkdir -p "$dir" && \
ulimit -n 3000 && \
firefox \
	--no-remote \
	--profile "$dir" \
	~/links/l.html

rm -rf -- "$new_tmp"
