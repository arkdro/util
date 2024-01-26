#!/bin/sh
ufw allow in on lo to any proto tcp port 22
ufw deny in to any proto tcp port 22
ufw allow in on lo to any proto tcp port 25
ufw deny in to any proto tcp port 25
ufw allow in on lo to any proto tcp port 631
ufw deny in to any proto tcp port 631
ufw allow in on lo to any proto udp port 631
ufw deny in to any proto udp port 631
ufw allow in on lo to any proto tcp port 8080
ufw deny in to any proto tcp port 8080

# ufw allow in on tun0 to any proto udp port 57489
# ufw allow in on tun0 to any proto tcp port 57489

# to not pollute logs, uncomment '& stop' in /etc/rsyslog.d/20-ufw.conf
