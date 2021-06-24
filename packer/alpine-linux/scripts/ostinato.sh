# install packages
alpine_version=$(cat /etc/alpine-release)
alpine_version=${alpine_version%.*}
apk add nano mousepad
apk add --allow-untrusted \
        /tmp/uploads/ostinato/$alpine_version/ostinato-drone*.apk \
        /tmp/uploads/ostinato/$alpine_version/ostinato-gui*.apk
apk add tshark wireshark

# desktop integration
cat > /usr/share/applications/ostinato.desktop << 'EOF'
[Desktop Entry]
Name=Ostinato
GenericName=Packet Traffic Generator
Exec=ostinato
Icon=ostinato
Terminal=false
Type=Application
Categories=Network;Monitor;Qt;
EOF
cp -p /tmp/uploads/ostinato/logo_256x256.png /usr/share/icons/hicolor/256x256/apps/ostinato.png
gtk-update-icon-cache -f /usr/share/icons/hicolor

# change hostname
sed -i -e "s/^127\.0\.0\.1.*/127.0.0.1\tostinato.$(hostname -d) ostinato localhost.localdomain localhost/" /etc/hosts
echo ostinato > /etc/hostname
hostname ostinato

# configure ostinato
mkdir -p /etc/xdg/Ostinato
printf '[General]\nRateAccuracy=Low\n[PortList]\nExclude=any,lo*\n' > /etc/xdg/Ostinato/drone.ini

# allow ostinato group to run drone
addgroup -S ostinato
chgrp ostinato /usr/bin/drone
chmod 750 /usr/bin/drone
setcap cap_net_admin,cap_net_raw=eip /usr/bin/drone

# add user to ostinato and wireshark group
addgroup user ostinato
addgroup user wireshark

# reset terminal modes
sed -i "$(printf '1i\e[?5l\e[?7h\e[?8h')" /etc/motd

# create .profile
cat > /root/.profile << 'EOF'
# ~/.profile: executed by Bourne-compatible login shells.

if [ "$BASH" ]; then
  if [ -f ~/.bashrc ]; then
    . ~/.bashrc
  fi
fi

mesg n || true
EOF

find /home -type d -mindepth 1 -maxdepth 1 | while read -r home; do
	cp -p /root/.profile "$home/"
	chown $(stat -c '%u:%g' "$home") "$home/.profile"
done

# network configuration
cat > /etc/network/interfaces << EOF
#
# This is a sample network config, uncomment lines to configure the network
#
# Loopback interface
auto lo
iface lo inet loopback

# Static config for eth0
#auto eth0
#iface eth0 inet static
#	address 192.168.0.2
#	netmask 255.255.255.0
#	gateway 192.168.0.1
#	up echo nameserver 192.168.0.1 > /etc/resolv.conf

# DHCP config for eth0
#auto eth0
#iface eth0 inet dhcp
#	hostname $(hostname)

# Minimal configuration for ethernet interfaces
# If static IP or DHCP is enabled for eth0, comment the config for eth0
auto eth0
iface eth0 inet manual
	pre-up sysctl -q -w net.ipv6.conf.\$IFACE.disable_ipv6=1
	up ip link set dev \$IFACE mtu 9000 up
	down ip link set dev \$IFACE down

auto eth1
iface eth1 inet manual
	pre-up sysctl -q -w net.ipv6.conf.\$IFACE.disable_ipv6=1
	up ip link set dev \$IFACE mtu 9000 up
	down ip link set dev \$IFACE down

auto eth2
iface eth2 inet manual
	pre-up sysctl -q -w net.ipv6.conf.\$IFACE.disable_ipv6=1
	up ip link set dev \$IFACE mtu 9000 up
	down ip link set dev \$IFACE down

auto eth3
iface eth3 inet manual
	pre-up sysctl -q -w net.ipv6.conf.\$IFACE.disable_ipv6=1
	up ip link set dev \$IFACE mtu 9000 up
	down ip link set dev \$IFACE down
EOF

cat > /etc/resolv.conf << EOF
EOF
