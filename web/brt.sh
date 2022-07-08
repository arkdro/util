#!/bin/bash

set -euo pipefail
IFS=$'\n\t'

renice -n 18 -p $$
ionice -c 3 -p $$

# cd "$HOME/.local/share/torbrowser/tor-browser_en-US"
# ./start-tor-browser.desktop

version="11.0.15"

home_dir="$HOME"
base="${home_dir}/tmp"
tmpdir="${base}/i"
mkdir -p "$tmpdir"
dir=`mktemp -d --tmpdir="$tmpdir" "tbb.XXXXXXXXXX"`
echo "dir: $dir"

basefile="tor-browser-linux64-${version}_en-US.tar.xz"
file="${home_dir}/util/web/${basefile}"
sig="${file}.asc"

home_page="file://${home_dir}/links/lynx_bookmarks.html"
home_page_pref="user_pref(\"browser.startup.homepage\", \"$home_page\");"
profile_file="$dir/tor-browser_en-US/Browser/TorBrowser/Data/Browser/profile.default/prefs.js"

gpg --verify "$sig" "$file"
mkdir -p "$dir"
tar xJf "$file" -C "$dir" --strip-components=0
echo "$home_page_pref" >> "$profile_file"
ulimit -n 3000
cd "$dir/tor-browser_en-US"
./Browser/start-tor-browser ~/links/l.html

rm -rf -- "$dir"
