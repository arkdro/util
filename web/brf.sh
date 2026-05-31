#!/bin/bash

# use temp directory to run firefox

set -euo pipefail
IFS=$'\n\t'

renice -n 18 -p $$
ionice -c 3 -p $$

add_prefs() {
	local dir="$1"
	prefs="prefs.js"
	(
		echo
		echo 'user_pref("browser.tabs.groups.enabled", false);'
		echo
	) >> "$dir/$prefs"
}

base="${TMP:-$HOME/tmp}"
tmpdir="${base}/i"
mkdir -p "$tmpdir"
new_tmp=`mktemp -d --tmpdir="$tmpdir" "tmp_bf.XXXXXXXXXX"`

export TMP=$new_tmp
export TEMP=$TMP
export TMPDIR=$TMP
export TEMPDIR=$TMP

dir=`mktemp -d --tmpdir="$new_tmp" "bf.XXXXXXXXXX"`
echo "dir: $dir"

mkdir -p "$dir" && \
ulimit -n 3000 && \

add_prefs "$dir"

firefox \
	--no-remote \
	--profile "$dir" \
	~/links/l.html

rm -rf -- "$new_tmp"
