#!/bin/sh
cd_img=/opt/data/debian-7.4.0-i386-DVD-1.iso
hd_img=d1.img
sw_img=sw.img
mem=1792m
#gr=-nographic

net="-net nic -net user,hostfwd=tcp:127.0.0.1:2022-:22"
serial="-serial tcp:127.0.0.1:2023,server,nowait"

qemu \
	-enable-kvm \
	-vga std \
	-smp 2 \
	-drive file=$hd_img,index=0,media=disk \
	-drive file=$sw_img,index=1,media=disk \
	-drive file=$cd_img,index=2,media=cdrom \
	-m $mem \
	-boot once=c \
	$gr \
	$net \
	$serial
