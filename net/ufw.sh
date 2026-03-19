#!/bin/sh

one_rule() {
	local port="$1"
	ufw allow in on lo to any proto tcp port "$port"
	ufw deny in to any proto tcp port "$port"
}

one_rule_e() {
	local port="$1"
	ufw allow in on lo to any proto tcp port "$port"
	ufw allow in on en+ to any proto tcp port "$port"
	ufw deny in to any proto tcp port "$port"
}

set_rules() {
	for port in $ports
	do
		one_rule "$port"
	done
}

set_rules_e() {
	for port in $ports_e
	do
		one_rule_e "$port"
	done
}

# 1716 - kde connect
# 4713 - pipewire
ports="25 631 1716 4713 8080"
ports_e="22"

set_rules
set_rules_e

# to not pollute logs, uncomment '& stop' in /etc/rsyslog.d/20-ufw.conf
