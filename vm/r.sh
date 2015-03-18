#!/bin/sh
cd_img=/opt/data/debian-wheezy-DI-b3-i386-DVD-1.iso
hd_img=d1.img
sw_img=sw.img
mem=1g
#gr=-nographic
#net="-net user,restrict=on,hostfwd=tcp::2022-:22,guestfwd=tcp:127.0.0.1:8080-chardev:chan0 -chardev pipe,id=chan0,path=/tmp/guestfwd"
net="-net user,restrict=on,hostfwd=tcp::2022-:22"
serial="-serial tcp:127.0.0.1:2023,server,nowait"

qemu \
	-drive file=$hd_img,index=0,media=disk \
	-drive file=$sw_img,index=1,media=disk \
	-drive file=$cd_img,index=2,media=cdrom \
	-m $mem \
	-boot once=d \
	$gr \
	$net \
	$serial
