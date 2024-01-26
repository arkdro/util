#!/bin/sh

# set black color to be really black
# xrandr --output HDMI1 --set "Broadcast RGB" "Full"

# xrandr --output HDMI1 --off

# The idea here is to increase the screen resolution virtually (because we are limited to 1366x768 physically) the command would be (replace screen-name):
# xrandr --output screen-name --mode 1366x768 --panning 1640x922 --scale 1.20058565x1.20208604


xrandr \
	--output eDP \
	--mode 1920x1080 \
	--panning 3840x2160 \
	--scale 2x2 \
	--output HDMI-A-0 \
	--right-of eDP \
	--mode 3840x2160 \
