#!/bin/sh
xset b off r rate 250 30

# '<>' key Shift_L
xmodmap -e 'keycode 94 = Shift_L'

# Muhenkan on JIS keyboard
xmodmap -e 'keycode 102 = Alt_L'

# '\' on JIS keyboard. Make it '/'
xmodmap -e 'keycode 97 = slash question'

pgrep -u $USER xbindkeys > /dev/null || xbindkeys
