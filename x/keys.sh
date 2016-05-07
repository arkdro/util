#!/bin/sh

# f%$#ed marketing has made left shift short and added '<>' key near it.
# so make this '<>' key Shift_L
xmodmap -e "keycode 94 = Shift_L"
