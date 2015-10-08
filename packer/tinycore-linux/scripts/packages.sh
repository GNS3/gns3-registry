# Add extensions

set -x

# change tcedir to harddisk
mv /etc/sysconfig/tcedir /etc/sysconfig/tcedir.bak
ln -s /mnt/sda1/tce /etc/sysconfig/tcedir
rm -rf /usr/local/tce.installed/*

tce-load -wi ipv6-`uname -r` iptables iproute2

