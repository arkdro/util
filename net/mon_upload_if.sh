#!/bin/sh

# terminate all the upload jobs when an interface goes down
# - check the interface
# - if the interface is down, then call the upload terminate command

terminate() {
	$script_dir/job_termination.pl allOp
}

check_iface(){
	i=$1
	interface="/sys/devices/virtual/net/$i"
	if [ ! -e "$interface" ]
	then
		echo "network interface ($interface) is down, terminating the job, `date`"
		terminate
		return 1
	fi
}

check_log_pattern(){
	journalctl --cursor-file=$cursor_file |\
		egrep -q "\bovpn-\w+\[[0-9]+\]: Restart pause"
	res=$?
	if [ $res -eq 0 ] ; then
		echo "log pattern found, terminating the job, `date`"
		terminate
		return 1
	fi
}

script_dir=$HOME/scripts
IP=/sbin/ip
iface="${1:-tun0}"
cursor_file=`mktemp`
echo "cursor: $cursor_file"

while(true)
do
	check_iface $iface
	rc1=$?
	check_log_pattern
	rc2=$?
	if [ $rc1 -ne 0 -o $rc2 -ne 0 ] ; then
		rm -f -- "$cursor_file"
		exit 1
	fi
	sleep 5
done
