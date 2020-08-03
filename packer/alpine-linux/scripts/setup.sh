# install additional packages
apk add nano busybox-extras

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
# auto eth0
# iface eth0 inet dhcp
#	hostname $(hostname)
EOF

cat > /etc/resolv.conf << EOF
EOF
