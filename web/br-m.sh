#!/bin/bash

set -euo pipefail
IFS=$'\n\t'

base="${HOME}/tmp"
tmpdir="${base}/i"
dir="$tmpdir/m-ar"
echo "dir: $dir"

ulimit -n 3000 && \
chromium \
	--force-device-scale-factor=1.25 \
	--password-store=basic \
	--user-data-dir="$dir" \
	~/links/l.html

