#!/bin/sh

one_rule() {
	local port="$1"
	ufw allow in on lo to any proto tcp port "$port"
	ufw deny in to any proto tcp port "$port"
}

# 1716 - kde connect
ports="22 25 631 1716 8080"

for port in $ports
do
	one_rule "$port"
done

# to not pollute logs, uncomment '& stop' in /etc/rsyslog.d/20-ufw.conf
