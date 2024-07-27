#!/bin/sh

# https://wiki.archlinux.org/title/Midnight_Commander

ini=~/.local/share/mc/skins/default.ini
sed -i -E -e 's/^(.* = (gray|brightred|brightgreen|yellow|brightblue|brightmagenta|brightcyan|white);.*)$/\0;bold/' "$ini"
