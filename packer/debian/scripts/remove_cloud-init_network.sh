#!/bin/sh
set -ex

# replace cloud-init network configuration
cat > /etc/network/interfaces <<'EOF'
# This file describes the network interfaces available on your system
# and how to activate them. For more information, see interfaces(5).

source /etc/network/interfaces.d/*

# The loopback network interface
auto lo
iface lo inet loopback

# DHCP config for ens4
#auto ens4
#iface ens4 inet dhcp

# Static config for ens4
#auto ens4
#iface ens4 inet static
#	address 192.168.1.100
#	netmask 255.255.255.0
#	gateway 192.168.1.1
#	dns-nameservers 192.168.1.1
EOF
rm -f /etc/network/interfaces.d/50-cloud-init
