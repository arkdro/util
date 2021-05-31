#!/bin/sh

set -e

if [ "$#" -lt 2 ] ; then
	echo "Need parameters: repo_dir target_dir"
	exit 1
fi

cur_dir=`pwd`
repo_dir="$1"
target_dir="$2"
temp_dir=`mktemp -d -p "$cur_dir"`

cd "$repo_dir" 
git format-patch -o "$temp_dir" -n --root
cd "$cur_dir"

e=`git config --get user.email`
n=`git config --get user.name`
find "$temp_dir" -type f |\
	while read f
		do
			sed -i -e "s/^From: root <root@localhost>/From: $n <$e>/" "$f"
		done

mkdir -p "$target_dir"
cd "$target_dir"
git init
find "$temp_dir" -type f | sort |\
	while read f
		do
			cur_file="$f"
			git am --ignore-date < "$f"
		done

rm -rf -- "$temp_dir"
