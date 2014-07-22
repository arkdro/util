#!/bin/sh

echo -n `date '+%Y-%m-%d %H:%M:%S'`
echo -n ' '

h=192.168.1.1
echo `ping -w 40 -q -n $h | grep rtt | cut -d '=' -f 2 | cut -d '/' -f 2`

