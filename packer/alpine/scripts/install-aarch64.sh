#!/bin/sh

set -eu

trap 'status=$?; if [ "$status" -ne 0 ]; then echo "AArch64 installation failed (exit $status)" >&2; fi' EXIT

base_url=$1
disk_device=$2
ui_mode=$3
file_source=$4
setup_script=$5

mkdir -p /tmp/alpine-build
wget -O /tmp/alpine-build/install.sh "$base_url/scripts/install.sh"
wget -O /tmp/alpine-build/ui.sh "$base_url/scripts/$ui_mode.sh"
wget -O /tmp/alpine-build/setup.sh "$base_url/scripts/$setup_script"
wget -O /tmp/alpine-build/post_setup.sh "$base_url/scripts/post_setup.sh"
wget -O "/tmp/alpine-build/$file_source" "$base_url/files/$file_source"

DISK_DEVICE="$disk_device" sh /tmp/alpine-build/install.sh

# setup-alpine unmounts the EFI and root partitions after installing.
mount "${disk_device}2" /mnt
mount "${disk_device}1" /mnt/boot/efi
mount --bind /dev /mnt/dev
mount -t proc proc /mnt/proc
mount --bind /sys /mnt/sys
cp /etc/resolv.conf /mnt/etc/resolv.conf
mkdir -p /mnt/tmp/uploads
cp /tmp/alpine-build/* /mnt/tmp/uploads/

chroot /mnt apk upgrade --update-cache
chroot /mnt /bin/sh -e /tmp/uploads/ui.sh
chroot /mnt /bin/sh -e /tmp/uploads/setup.sh
chroot /mnt /bin/sh -e /tmp/uploads/post_setup.sh

sync
umount /mnt/sys /mnt/proc /mnt/dev /mnt/boot/efi /mnt
echo "AArch64 installation completed"
