set -e
set -x

# setup environment
. /etc/profile
. /etc/init.d/tc-functions
getMirror

# load qt-4.x-base without the X dependecies
# alternatively a "tce-load -wi qt-4.x-base" loads it with all dependecies
wget -P /mnt/sda1/tce/optional $MIRROR/qt-4.x-base.tcz
wget -P /mnt/sda1/tce/optional $MIRROR/qt-4.x-base.tcz.md5.txt
touch /mnt/sda1/tce/optional/qt-4.x-base.tcz.dep
tce-load -i /mnt/sda1/tce/optional/qt-4.x-base.tcz

# load the remaining dependencies for ostinato
tce-load -wi qt-4.x-base
tce-load -wi qt-4.x-script
tce-load -wi glib2
tce-load -wi openssl
tce-load -wi libpcap

# load also iperf
tce-load -wi iperf3

# change tcedir to ram disk
mv /etc/sysconfig/tcedir /etc/sysconfig/tcedir.hd
ln -s /tmp/tce /etc/sysconfig/tcedir

# setup compile environment
tce-load -wi compiletc
tce-load -wi squashfs-tools
tce-load -wi curl
export CFLAGS="-march=i486 -mtune=i686 -O2"
export CXXFLAGS="-march=i486 -mtune=i686 -O2"
export LDFLAGS="-Wl,-O1"

# compile protobuf
curl -L -O https://github.com/google/protobuf/releases/download/v2.6.1/protobuf-2.6.1.tar.gz
tar xfz protobuf-2.6.1.tar.gz
cd protobuf-2.6.1
./configure --prefix=/usr/local
make
sudo make install
sudo rm /usr/local/lib/libprotobuf.so
cd ..
rm -rf protobuf*

# compile ostinato
tce-load -wi qt-4.x-dev
tce-load -wi libpcap-dev
ver=`curl -sI https://bintray.com/pstavirs/ostinato/ostinato-src/_latestVersion | sed -n '/Location:/ {s%.*/ostinato-src/%%;s%/view.*%%;p;}'`
curl -k -L -O https://bintray.com/artifact/download/pstavirs/ostinato/ostinato-src-$ver.tar.gz
tar xfz ostinato-src-$ver.tar.gz
cd ostinato-$ver
# patch only useful for ostinato <= 0.7.1
patch -p0 <<'EOF'
--- server/pcapport.cpp.orig	2015-02-24 08:38:33.000000000 +0000
+++ server/pcapport.cpp	2015-02-25 09:58:38.943383048 +0000
@@ -696,7 +696,8 @@
 
     while (curTicks.QuadPart < tgtTicks.QuadPart)
         QueryPerformanceCounter(&curTicks);
-#elif defined(Q_OS_LINUX)
+// #elif defined(Q_OS_LINUX)
+#elif 0
     struct timeval delay, target, now;
 
     //qDebug("usec delay = %ld", usec);
EOF
qmake -config release "QMAKE_CXXFLAGS+=$CXXFLAGS"
# ostinato >= 0.8 supports building of a component
# make server
# sudo INSTALL_ROOT=/tmp/ostinato make server-install_subtargets
make
sudo INSTALL_ROOT=/tmp/ostinato make install
sudo rm /tmp/ostinato/usr/local/bin/ostinato
sudo chown -R root:root /tmp/ostinato
sudo chmod +s /tmp/ostinato/usr/local/bin/drone
cd ..
mksquashfs /tmp/ostinato ostinato-drone.tcz
md5sum ostinato-drone.tcz > ostinato-drone.tcz.md5.txt
echo -e "qt-4.x-base.tcz\nqt-4.x-script.tcz\nlibpcap.tcz" > ostinato-drone.tcz.dep
mv ostinato-drone.tcz* /mnt/sda1/tce/optional/
echo ostinato-drone.tcz >> /mnt/sda1/tce/onboot.lst
sudo rm -rf /tmp/ostinato
rm -rf ostinato*

# ostinato configuration file
mkdir -p .config/Ostinato
cat > .config/Ostinato/drone.ini <<'EOF'
[General]
RateAccuracy=Low
[PortList]
Include=eth*
Exclude=eth0
EOF

# change tcedir back to hard disk
rm -f /etc/sysconfig/tcedir
mv /etc/sysconfig/tcedir.hd /etc/sysconfig/tcedir

# disable automatic interface configuration with dhcp
sudo sed -i -e '/label .*core/,/append / s/\(append .*\)/\1 nodhcp/' /mnt/sda1/boot/extlinux/extlinux.conf

#  add startup script for ostinato
cat >> /opt/bootlocal.sh <<'EOF'

# Boot parameter "nodhcp": network interfaces are not yet configured
if grep -q -w nodhcp /proc/cmdline; then
	# This waits until all devices have registered
	/sbin/udevadm settle --timeout=10

	# configure eth0 with DHCP
	/sbin/udhcpc -b -i eth0 -x hostname:$(/bin/hostname) -p /var/run/udhcpc.eth0.pid >/dev/null 2>&1 &

	# alternatively configure static interface address and route
	#ifconfig eth0 x.x.x.x netmask 255.255.255.0 up
	#route add default gw y.y.y.y

	# activate other eth devices
	NETDEVICES="$(awk -F: '/eth[1-9][0-9]*:/{print $1}' /proc/net/dev 2>/dev/null)"
	for DEVICE in $NETDEVICES; do
		ifconfig $DEVICE mtu 9000 up
	done
fi

# start ostinato drone
HOME=/home/gns3 drone < /dev/null > /var/log/ostinato-drone.log 2>&1 &
EOF

exit 0
