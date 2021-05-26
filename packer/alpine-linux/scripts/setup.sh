# install additional packages
apk add nano busybox-extras

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
EOF

cat > /etc/resolv.conf << EOF
EOF
