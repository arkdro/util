#!/bin/sh

in_dir="$HOME/.tmp/08/d1"
out_dir="$HOME/.tmp/08/out"
orig_iso=/usr/local/home/dist/deb/12.5.0/amd64/iso/debian-12.5.0-amd64-DVD-1.iso
new_files="$in_dir"
new_iso="$out_dir/debian-12.5.0-amd64-DVD-1-b.iso"
mbr_template="$out_dir/isohdpfx.bin"

# Extract MBR template file to disk
dd if="$orig_iso" bs=1 count=432 of="$mbr_template"

xorriso \
	-as mkisofs \
	-r \
	-checksum_algorithm_iso sha256,sha512 \
	-V 'Debian 12.5.0 amd64 1-b' \
	-o "$new_iso" \
	-J \
	-joliet-long \
	-cache-inodes \
	-isohybrid-mbr "$mbr_template" \
	-b isolinux/isolinux.bin \
	-c isolinux/boot.cat \
	-boot-load-size 4 \
	-boot-info-table \
	-no-emul-boot \
	-eltorito-alt-boot \
	-e boot/grub/efi.img \
	-no-emul-boot \
	-isohybrid-gpt-basdat \
	-isohybrid-apm-hfsplus \
	"$new_files"
