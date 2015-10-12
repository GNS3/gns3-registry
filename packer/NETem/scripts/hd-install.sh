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
tce-load -wi syslinux
sudo sh -c 'cat /usr/local/share/syslinux/mbr.bin > /dev/sda'
sudo /usr/local/sbin/extlinux --install /mnt/sda1/boot/extlinux

# create extensions directory
sudo mkdir /mnt/sda1/tce
sudo chgrp staff /mnt/sda1/tce
sudo chmod 775 /mnt/sda1/tce

# change tcedir to harddisk
mv /etc/sysconfig/tcedir /etc/sysconfig/tcedir.bak
ln -s /mnt/sda1/tce /etc/sysconfig/tcedir
rm -rf /usr/local/tce.installed/*

# base system modifications
sudo sed -i -e '/^\/opt\/bootlocal/ i' /opt/bootsync.sh
echo -e "\nusername 'gns3', password 'gns3'\n" >> /etc/issue
echo 'etc/issue' >> /opt/.filetool.lst
echo 'etc/shadow' >> /opt/.filetool.lst
