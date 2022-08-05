#!/bin/sh

# terminate all the upload jobs when an interface goes down
# - check the interface
# - if the interface is down, then call the upload terminate command

terminate() {
	$script_dir/job_termination.pl allOp
}

check_iface(){
	i=$1
	if [ ! -e /sys/devices/virtual/net/$i ]
	then
		echo "terminating the job, `date`"
		terminate
		return 1
	fi
}

script_dir=$HOME/scripts
IP=/sbin/ip
iface="${1:-tun0}"

while(true)
do
	check_iface $iface
	rc=$?
	if [ $rc -ne 0 ] ; then
		exit $rc
	fi
	sleep 5
done
