#!/bin/bash

# use temp directory to run firefox

set -euo pipefail
IFS=$'\n\t'

base="${HOME}/tmp"
tmpdir="${base}/i"
dir=`mktemp -d --tmpdir="$tmpdir" "tmp.XXXXXXXXXX"`
echo "dir: $dir"

mkdir -p "$dir" && \
ulimit -n 3000 && \
firefox \
	--no-remote \
	--profile "$dir" \
	~/links/l.html

rm -rf -- "$dir"
