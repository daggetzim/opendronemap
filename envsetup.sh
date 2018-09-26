#!/bin/bash
set -eo pipefail

# Change this if needed
GOOGLE_DRIVE_FILE_ID=1ZSQRfhHmiEWnazlJRy6UEzKaYElDFv4l

sudo apt update
sudo apt install -y squashfs-tools genisoimage xorriso isolinux wget

if [ ! -e ./opendronemap.iso ]; then
	echo "Downloading opendronemap.iso..."
	wget --no-check-certificate "https://docs.google.com/uc?export=download&id=$GOOGLE_DRIVE_FILE_ID" -O opendronemap.iso
fi

if [ ! -e ./chroot ]; then
	mkdir mnt
	sudo mount -o loop *.iso mnt
	mkdir image
	sudo rsync --exclude=/casper/filesystem.squashfs -a mnt/ image
	sudo unsquashfs mnt/casper/filesystem.squashfs
	sudo mv squashfs-root chroot	
	sudo umount mnt
	sudo rmdir mnt
fi
