#!/bin/sh
set -ex

# add hostname into /etc/hosts
if [ -z "$(hostname -d)" ]; then
	printf '127.0.1.1\t%s\n' "$(hostname)" >> /etc/hosts
else
	printf '127.0.1.1\t%s\t%s\n' "$(hostname -f)" "$(hostname)" >> /etc/hosts
fi

# replace netplan and systemd-resolved by ifupdown and resolvconf
export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get -y upgrade
cp /etc/resolv.conf /etc/resolv.conf.orig
apt-get -y install --purge ifupdown resolvconf
cat /etc/resolv.conf.orig > /etc/resolv.conf
rm -f /etc/resolv.conf.orig
echo "network: {config: disabled}" > /etc/cloud/cloud.cfg.d/99-disable-network-config.cfg
rm -rf /etc/netplan
apt-get -y autoremove --purge netplan.io

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
