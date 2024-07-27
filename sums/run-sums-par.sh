#!/bin/sh

n_cpu=8

dir=`dirname "$0"`
cmd="${dir}/run-sums.sh"
find "$1" -type f -print0 | xargs -0 -I '{}' -P $n_cpu "$cmd" '{}' 
