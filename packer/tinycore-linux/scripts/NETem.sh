set -e
set -x

# TCE directory back to ramdisk
mv /etc/sysconfig/tcedir /etc/sysconfig/tcedir.hd
ln -s /tmp/tce /etc/sysconfig/tcedir

mkdir build
cd build
tce-load -wi squashfs-tools

# create utf8-locale
tce-load -wi getlocale
sudo mkdir -p /usr/lib/locale
sudo localedef -i en_US -c -f UTF-8 en_US.UTF-8
sudo localedef -i en_US -c -f UTF-8 C.UTF-8
sudo mkdir -p /tmp/utf8-locale/usr/lib/locale
sudo cp -p /usr/lib/locale/* /tmp/utf8-locale/usr/lib/locale/
mksquashfs /tmp/utf8-locale utf8-locale.tcz
md5sum utf8-locale.tcz > utf8-locale.tcz.md5.txt

# create python3dialog
tce-load -wi python3-dev
wget https://bootstrap.pypa.io/get-pip.py
sudo python3 get-pip.py
rm get-pip.py
tce-load -wi dialog
sudo LANG=C.UTF-8 pip3 install pythondialog
sudo mkdir -p /tmp/python3dialog/usr/local/lib/python3.4/site-packages
sudo cp -a /usr/local/lib/python3.4/site-packages/dialog* /tmp/python3dialog/usr/local/lib/python3.4/site-packages/
sudo cp -a /usr/local/lib/python3.4/site-packages/pythondialog* /tmp/python3dialog/usr/local/lib/python3.4/site-packages/
mksquashfs /tmp/python3dialog python3dialog.tcz
md5sum python3dialog.tcz > python3dialog.tcz.md5.txt
echo -e 'python3.tcz\ndialog.tcz' > python3dialog.tcz.dep

# TCEDIR back to harddisk
rm -f /etc/sysconfig/tcedir; mv /etc/sysconfig/tcedir.hd /etc/sysconfig/tcedir
mkdir -p /etc/sysconfig/tcedir/optional
chmod 775 /etc/sysconfig/tcedir/optional
rm -f /usr/local/tce.installed/*

# install utf8-locale
cp -p utf8-locale.tcz* /etc/sysconfig/tcedir/optional/
echo 'utf8-locale.tcz' >> /etc/sysconfig/tcedir/onboot.lst

# install python3 without TK
cp -p /tmp/tce/optional/python3.tcz /etc/sysconfig/tcedir/optional/
cp -p /tmp/tce/optional/python3.tcz.md5.txt /etc/sysconfig/tcedir/optional/
sed -e '/^tk/ d' /tmp/tce/optional/python3.tcz.dep > /etc/sysconfig/tcedir/optional/python3.tcz.dep
echo 'python3.tcz' >> /etc/sysconfig/tcedir/onboot.lst
for pkg in `cat /etc/sysconfig/tcedir/optional/python3.tcz.dep`; do tce-load -w $pkg; done

# install python3dialog
cp -p python3dialog.tcz* /etc/sysconfig/tcedir/optional/
echo 'python3dialog.tcz' >> /etc/sysconfig/tcedir/onboot.lst
tce-load -w dialog

# additional linux networking modules
KERNEL=`uname -r`
tce-load -w net-bridging-$KERNEL
echo "net-bridging-$KERNEL.tcz" >> /etc/sysconfig/tcedir/onboot.lst
tce-load -w net-sched-$KERNEL
echo "net-sched-$KERNEL.tcz" >> /etc/sysconfig/tcedir/onboot.lst

# clean up build environment
cd ..
rm -r build

# NETem menu system
. /etc/init.d/tc-functions
http=http://`getbootparam http`
wget $http/NETem/netem-conf.py
chmod +x netem-conf.py

# autologin on serial console
sudo sed -i -e '/^tty1:/ s/^.*/tty1::respawn:\/sbin\/getty 38400 tty1/' -e '/^ttyS0:/ s/^.*/ttyS0::askfirst:\/sbin\/getty -nl \/sbin\/autologin 38400 ttyS0 xterm/' /etc/inittab
sudo sed -i -e 's/tty1/`\/usr\/bin\/tty`/' /sbin/autologin
echo 'sbin/autologin' >> /opt/.filetool.lst

# autostart netem-conf
sed -i -e '/^TERMTYPE/,$ d' .profile
cat >> .profile << 'EOF'
# autostart netem-conf only on local terminals
TERMTYPE=`/usr/bin/tty`
if [ "${TERMTYPE:5:3}" = "tty" ]; then
	./netem-conf.py
	rm -f /var/log/autologin
fi
EOF

# disable automatic interface configuration with dhcp
sudo sed -i -e '/label microcore/,/append / s/\(append .*\)/\1 nodhcp/' /mnt/sda1/boot/extlinux/extlinux.conf

# set locale and configure network at startup
sed -i -e '3,$ d' /opt/bootlocal.sh
sed -n -e '1,/^\/opt\/bootlocal/ p' /opt/bootsync.sh | head -n -1 > /tmp/bootsync.head
sed -n -e '/^\/opt\/bootlocal/,$ p' /opt/bootsync.sh > /tmp/bootsync.tail
cat /tmp/bootsync.head > /opt/bootsync.sh
cat >> /opt/bootsync.sh <<'EOF'
. /etc/init.d/tc-functions

# default LANG=C.UTF-8
[ ! -f /etc/sysconfig/language ] || [ "`cat /etc/sysconfig/language`" = "LANG=C" ] && \
	echo "LANG=C.UTF-8" > /etc/sysconfig/language

# Configure network interfaces only when boot parameter "nodhcp" is used
if grep -q -w nodhcp /proc/cmdline; then
	echo -en "${BLUE}Configuring network interfaces... ${NORMAL}"

	# This waits until all devices have registered
	/sbin/udevadm settle --timeout=10

	ip link add name br0 type bridge
	sysctl -q -w net.ipv6.conf.br0.disable_ipv6=1
	sysctl -q -w net.ipv6.conf.eth0.disable_ipv6=1
	ip link set dev eth0 promisc on
	ip link set dev eth0 mtu 2000
	ip link set dev eth0 up
	ip link set dev eth0 master br0
	sysctl -q -w net.ipv6.conf.eth1.disable_ipv6=1
	ip link set dev eth1 promisc on
	ip link set dev eth1 mtu 2000
	ip link set dev eth1 up
	ip link set dev eth1 master br0
	ip link set dev br0 up

	echo -e "${GREEN}Done.${NORMAL}"
fi
EOF
cat /tmp/bootsync.tail >> /opt/bootsync.sh

# Done
