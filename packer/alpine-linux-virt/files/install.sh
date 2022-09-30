#!/bin/ash

DRIVE="/dev/vda"

# Format drive, from sector 2048 to end, bootable
fdisk $DRIVE << EOS
o
n
p
1
2048

a
1
w
EOS

if [[ $? != 0 ]]; then
    echo "Error while partitioning device" >&2
    exit 1
fi

# Format partition without "64bit" and "has_journal" flags
apk add e2fsprogs && mkfs.ext4 -O \^64bit,\^has_journal ${DRIVE}1 && mount ${DRIVE}1 /mnt -t ext4 && mkdir /mnt/boot && apk del e2fsprogs
if [[ $? != 0 ]]; then
    echo "Error somewhere while making filesystem or mounting partition" >&2
    exit 1
fi

# Actually install Alpine Linux in mounted directory
BOOT_SIZE=0 setup-disk -k virt -s 0 /mnt
if [[ $? != 0 ]]; then
    echo "Error while installing Alpine" >&2
    exit 1
fi

# Install the MBR
dd if=/mnt/usr/share/syslinux/mbr.bin of=/dev/vda
if [[ $? != 0 ]]; then
    echo "Error while fixing kernel path" >&2
    exit 1
fi

# Fix kernel and initrd path, enable console on ttyS0
sed -i.bkp 's_LINUX vmlinuz_LINUX /boot/vmlinuz_; s_INITRD initram_INITRD /boot/initram_; /APPEND/s/$/ console=ttyS0,115200/' /mnt/boot/extlinux.conf
if [[ $? != 0 ]]; then
    echo "Error while fixing kernel path" >&2
    exit 1
fi

# Enable autologin on ttyS0
sed -i.bkp 's/^ttyS0/#ttyS0/g' /mnt/etc/inittab && echo "ttyS0::respawn:/bin/login -f root" >> /mnt/etc/inittab
if [[ $? != 0 ]]; then
    echo "Error while enabling autologin on ttyS0" >&2
    exit 1
fi

# Write 0
dd if=/dev/zero bs=1M of=/mnt/zero ; rm -f /mnt/zero

# fsck
umount ${DRIVE}1 && apk add e2fsprogs && fsck.ext4 ${DRIVE}1
if [[ $? != 0 ]]; then
    echo "Couldn't fsck partition" >&2
    exit 1
fi
