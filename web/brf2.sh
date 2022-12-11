#!/bin/bash

# use bubblewrap + temp directory to run sandboxed firefox

set -euo pipefail
IFS=$'\n\t'

home_dir="$HOME"
base="${home_dir}/tmp"
tmpdir="${base}/i"
dir=`mktemp -d --tmpdir="$tmpdir" "tmp.XXXXXXXXXX"`
echo "dir: $dir"

mkdir -p "$dir"
mkdir -p "$dir/.mozilla"
mkdir -p "$dir/.config/transmission"
mkdir -p "$dir/Downloads"

ulimit -n 3000

prog_name=firefox-esr

bwrap \
	--ro-bind /lib /lib \
	--ro-bind /bin /bin \
	--ro-bind /sbin /sbin \
	--ro-bind /usr/lib /usr/lib \
	--ro-bind /lib64 /lib64 \
	--ro-bind /usr/bin /usr/bin \
	--ro-bind /usr/sbin /usr/sbin \
	--ro-bind /usr/lib/$prog_name /usr/lib/$prog_name \
	--ro-bind /usr/share/applications /usr/share/applications \
	--ro-bind /usr/share/fontconfig /usr/share/fontconfig \
	--ro-bind /usr/share/drirc.d /usr/share/drirc.d \
	--ro-bind /usr/share/fonts /usr/share/fonts \
	--ro-bind /usr/share/glib-2.0 /usr/share/glib-2.0 \
	--ro-bind /usr/share/glvnd /usr/share/glvnd \
	--ro-bind /usr/share/icons /usr/share/icons \
	--ro-bind /usr/share/libdrm /usr/share/libdrm \
	--ro-bind /usr/share/mime /usr/share/mime \
	--ro-bind /usr/share/X11/xkb /usr/share/X11/xkb \
	--ro-bind /usr/share/icons /usr/share/icons \
	--ro-bind /usr/share/mime /usr/share/mime \
	--ro-bind /etc/fonts /etc/fonts \
	--ro-bind /etc/resolv.conf /etc/resolv.conf \
	--ro-bind /usr/share/ca-certificates /usr/share/ca-certificates \
	--ro-bind /etc/ssl /etc/ssl \
	--ro-bind /etc/ca-certificates /etc/ca-certificates \
	--dir /run/user/"$(id -u)" \
	--ro-bind /run/user/"$(id -u)"/pulse /run/user/"$(id -u)"/pulse \
	--dev /dev \
	--dev-bind /dev/dri /dev/dri \
	--ro-bind /sys/dev/char /sys/dev/char \
	--ro-bind /sys/devices/pci0000:00 /sys/devices/pci0000:00 \
	--proc /proc \
	--tmpfs /tmp \
	--bind "$dir/.mozilla" "$dir/.mozilla" \
	--bind "$dir/.config/transmission" "$dir/.config/transmission" \
	--bind "$dir/Downloads" "$dir/Downloads" \
	--bind "$dir" "$dir" \
	--setenv HOME "$dir" \
	--setenv PATH /usr/bin:/bin:/usr/lib/$prog_name \
	--hostname RESTRICTED \
	--unshare-all \
	--share-net \
	--die-with-parent \
	--new-session \
	/usr/lib/$prog_name/$prog_name \
		--no-remote \
		--profile "$dir" \
		"$dir/links/l.html"

rm -rf -- "$dir"
