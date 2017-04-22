#!/bin/sh
check_hosts(){
	i=$1
	hosts="www.google.com www.microsoft.com www.facebook.com www.apple.com"
	host=`shuf -e $hosts | head -n 1`
	ping -4 -c 3 -I $i -q -w 7 $host >/dev/null 2>&1 || echo -n "$sign2"
}

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
		echo -n $sign
		check_hosts $i
		echo
	else
		echo -
	fi
}

IP=/sbin/ip
iface="${1:-tun0}"
sign="${2:-W}"
sign2="${3:-*}"
check_iface $iface
