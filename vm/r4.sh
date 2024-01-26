#!/bin/sh
# debian 11.8
#
# doc:
#   https://wiki.qemu.org/Documentation/9psetup
# fstab:
#   deb_dist /usr/local/home/xxxxxxxx 9p trans=virtio,version=9p2000.L,msize=512000 0 0
# manual mount:
#   mount -t 9p -o trans=virtio deb_dist /usr/local/home/xxxxxxxxx -oversion=9p2000.L

cdrom='/usr/local/home/m1/dist/deb/11.8.0/iso/debian-11.8.0-amd64-DVD-1.iso'
disk='f1.img'

# space before 'local' is necessary. Unless you put everything in a one long line.
virt=$(tr -d '\n' <<-EOF
	-virtfs
		 local,
		path=/usr/local/home/m1/dist/deb/,
		mount_tag=deb_dist,
		security_model=mapped-xattr,
		fmode=0600,
		dmode=0700
EOF
)

qemu-system-x86_64 \
	-enable-kvm \
	-vga qxl \
	-global qxl-vga.ram_size=134217728 \
	-global qxl-vga.vram_size=134217728 \
	-global qxl-vga.ram_size_mb=128 \
	-global qxl-vga.vgamem_mb=64 \
	-smp cpus=2 \
	-m 8G \
	-boot once=c \
	-drive file=$disk,format=raw,if=virtio,media=disk \
	-drive file=$cdrom,media=cdrom,readonly \
	-audiodev pa,id=snd0 \
	-device ich9-intel-hda \
	-device hda-output,audiodev=snd0 \
	-net nic \
	-net user,hostfwd=tcp:127.0.0.1:4022-:22 \
	$virt

#	-monitor telnet:127.0.0.1:55555,server,nowait; \
#	-enable-kvm \
#	-display gtk \
