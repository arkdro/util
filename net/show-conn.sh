#!/bin/sh
netstat -na |\
        grep ESTAB |\
        awk '{print $5}' |\
        egrep -v -e '^:' -e '^127\.0\.0' -e '^192.168' |\
        awk -F ':' '{print $1}' |\
        xargs -P 0 -i host '{}'
