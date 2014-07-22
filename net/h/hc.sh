#!/bin/sh
set -e
(cat blank
perl hc.pl -i list
) >> client.cfg
