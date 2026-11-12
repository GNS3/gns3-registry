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
apt-get update --error-on=any
apt-get -y upgrade
resolver_config=/etc/resolv.conf
if [ -f /run/systemd/resolve/resolv.conf ]; then
	resolver_config=/run/systemd/resolve/resolv.conf
fi
build_resolver=$(mktemp)
trap 'rm -f "$build_resolver"' EXIT
awk '$1 == "nameserver" && $2 !~ /^127\./ && $2 != "::1" { print }' \
	"$resolver_config" > "$build_resolver"
if [ ! -s "$build_resolver" ]; then
	echo "No upstream DNS servers available for provisioning" >&2
	exit 1
fi
apt-get -y install --purge ifupdown resolvconf
resolvconf -a packer < "$build_resolver"

# replace cloud-init network configuration
cat > /etc/network/interfaces <<'EOF'
# This file describes the network interfaces available on your system
# and how to activate them. For more information, see interfaces(5).

source /etc/network/interfaces.d/*

# The loopback network interface
auto lo
iface lo inet loopback

# DHCP config for enp1s0
#auto enp1s0
#iface enp1s0 inet dhcpp

# Static config for enp1s0:
#auto enp1s0:
#iface enp1s0: inet static
#	address 192.168.1.100
#	netmask 255.255.255.0
#	gateway 192.168.1.1
#	dns-nameservers 192.168.1.1
EOF
