#!/bin/sh

h=192.168.1.1
ping -w 40 -q -n $h | grep rtt | cut -d '=' -f 2 | cut -d '/' -f 2

