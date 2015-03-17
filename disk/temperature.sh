#!/bin/sh

# requires hddtemp on port 7634

telnet localhost 7634 2>/dev/null | grep '/dev/sda' | cut -d '|' -f 4
