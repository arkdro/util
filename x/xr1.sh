#!/bin/sh

# set black color to be really black
# xrandr --output HDMI1 --set "Broadcast RGB" "Full"

# xrandr --output HDMI1 --off
xrandr --output LVDS1 --mode 1366x768 --output HDMI1 --right-of LVDS1 --mode 1920x1080
