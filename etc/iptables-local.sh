#!/bin/sh

# see also /lib/ufw/user.rules:
# `ufw allow in on tun0 to any port 60603`

# only local and tun network
do_user_1() {
	op=$1
	uid=1001
	iptables $op OUTPUT -m owner --uid-owner $uid -j REJECT
	iptables $op OUTPUT -o tun+ -m owner --uid-owner $uid -j ACCEPT
	iptables $op OUTPUT -o lo -m owner --uid-owner $uid -j ACCEPT
	# DNS
	dns_server="192.168.1.1"
	iptables $op OUTPUT -m owner --uid-owner $uid -d "$dns_server" -p udp --dport 53 -j ACCEPT
}

# only local network
do_user_2() {
	op=$1
	uid=1002
	iptables $op OUTPUT -m owner --uid-owner $uid -j REJECT
	iptables $op OUTPUT -o lo -m owner --uid-owner $uid -j ACCEPT
}

do_work() {
	op=$1
	do_user_1 $op
	do_user_2 $op
}

start() {
	do_work "-I"
}

stop() {
	do_work "-D"
}

case "$1" in
  start)
	start
	;;
  stop)
  	stop
	;;
  restart|reload)
	$0 stop
	$0 start
	;;
  *)
	echo "Usage: $MYNAME {start|stop|restart}" >&2
	exit 3
	;;
esac
