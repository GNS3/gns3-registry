# Install tinycore on harddisk

set -x

# format harddisk
echo -e 'n\np\n1\n\n\na\n1\nw' | sudo fdisk -H16 -S32 /dev/sda
sudo mkfs.ext2 /dev/sda1

# copy system to harddisk
sudo mkdir /mnt/sda1
sudo mount /dev/sda1 /mnt/sda1
sudo mount /mnt/sr0
sudo cp -a /mnt/sr0/boot /mnt/sda1/
sudo umount /mnt/sr0

# modify bootloader config
sudo mv /mnt/sda1/boot/isolinux /mnt/sda1/boot/extlinux
cd /mnt/sda1/boot/extlinux
sudo rm boot.cat isolinux.bin
sudo mv isolinux.cfg extlinux.conf
sudo sed -i -e '/append / s/$/ user=gns3/' -e 's/timeout .*/timeout 1/' extlinux.conf
cd

# make disk bootable


# create extensions directory
sudo mkdir /mnt/sda1/tce
sudo mkdir -p /mnt/sda1/tce/optional/
sudo chgrp -R staff /mnt/sda1/tce
sudo chmod -R 775 /mnt/sda1/tce

# Make lib32 extension
tce-load -wi squashfs-tools
mkdir /tmp/lib32
cd /tmp/lib32
wget http://tinycorelinux.net/6.x/x86/release/Core-current.iso
sudo mount -o loop Core-current.iso /mnt/fd0
mkdir lib32
cd lib32
zcat /mnt/fd0/boot/core.gz | cpio -id "lib/l*" "usr/lib/l*"
mkdir -p usr/local/lib
cd ..
sudo umount /mnt/fd0
rm Core-current.iso
mkdir lib
ln -s /lib32/lib/`readlink lib32/lib/ld-linux.so.2` lib/ld-linux.so.2
mkdir -p usr/local/tce.installed
cat > usr/local/tce.installed/lib32 << 'EOF'
#!/bin/sh
echo -e "/lib32/lib\n/lib32/usr/lib\n/lib32/usr/local/lib" >> /etc/ld.so.conf
ldconfig
sed 's/ld-linux.*\*/ld-linux.so\*/' /usr/bin/ldd > /usr/bin/ldd32
chmod +x /usr/bin/ldd32
sed 's/ld-linux/ld-linux-x86-64/' /usr/bin/ldd32 > /usr/bin/ldd
chmod +x /usr/bin/ldd
EOF
chmod +x usr/local/tce.installed/lib32
chgrp -R staff usr/local/tce.installed
chmod 775 usr/local/tce.installed
sudo mksquashfs /tmp/lib32 lib32.tcz
sudo mv lib32.tcz* /mnt/sda1/tce/optional/
echo lib32.tcz >> /mnt/sda1/tce/onboot.lst 
tce-load -i /mnt/sda1/tce/optional/lib32

cd 

wget http://repo.tinycorelinux.net/6.x/x86/tcz/syslinux.tcz
tce-load -i syslinux.tcz

sudo sh -c 'cat /usr/local/share/syslinux/mbr.bin > /dev/sda'
sudo /usr/local/sbin/extlinux --install /mnt/sda1/boot/extlinux

