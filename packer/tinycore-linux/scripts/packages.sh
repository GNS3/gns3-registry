# Add extensions

set -x

# change tcedir to harddisk
mv /etc/sysconfig/tcedir /etc/sysconfig/tcedir.bak
ln -s /mnt/sda1/tce /etc/sysconfig/tcedir
rm -rf /usr/local/tce.installed/*

# openssh (optional)
tce-load -wi openssh
echo '/usr/local/etc/init.d/openssh start' >> /opt/bootlocal.sh
echo 'usr/local/etc/ssh' >> /opt/.filetool.lst

tce-load -wi ipv6-`uname -r` iptables iproute2
tce-load -wi tcpdump
tce-load -wi iperf3

