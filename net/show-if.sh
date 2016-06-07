#!/bin/sh
check_addr(){
	i=$1
	addr=`$IP ad li $i | grep -w inet | awk '{print $2}'`
}

check_iface(){
	i=$1
	#/sbin/ip li show $iface > /dev/null 2>&1
	if [ -e /sys/devices/virtual/net/$i ]
	then
		check_addr $i
		echo $sign
	else
		echo -
	fi
}

IP=/sbin/ip
iface="${1:-tun0}"
sign="${2:-W}"
check_iface $iface
