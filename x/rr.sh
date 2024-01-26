#!/bin/sh
# rxvt +sb -fg grey85 -bg black -g 80x30 -fn '-rfx-fixed-medium-r-normal--24-170-100-100-c-120-iso10646-1' -fb '-rfx-fixed-medium-r-normal--24-170-100-100-c-120-iso10646-1'

res='URxvt.color4:#205050'
res_param="-xrm ${res}"

#fn=${1:-"DejaVu Sans Mono"}
#sz=${2:-40}

#fn='Liberation Mono' ; sz=40
fn='DejaVu Sans Mono' ; sz=36
#fn='Inconsolata' ; sz=48
#fn='Anonymous Pro' ; sz=42

rxvt \
	-title "${fn}" \
	+sb \
	-fg grey85 \
	-bg black \
	-g 96x36 \
	-fn "xft:${fn}:pixelsize=${sz}" \
	$res_param \
	$@
