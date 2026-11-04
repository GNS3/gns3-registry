#!/bin/sh

# add community repository
sed -i 's/^#\s*\(.*\/v.*\/community\)$/\1/' /etc/apk/repositories
apk update

# install packages
apk add nano less busybox-extras
apk add frr frr-openrc
rc-update add frr

# enable IP forwarding
cat > /etc/sysctl.d/50-ip_forwarding.conf << EOF
net.ipv4.conf.all.forwarding=1
net.ipv6.conf.all.forwarding=1
EOF

# change hostname
cat > /root/set_hostname << 'EOF'
#!/bin/sh

if [ $# -ne 1 ]; then
	echo "usage: set_hostname host" >&2
	exit 1
fi

host=$1
hostname=${host%%.*}
if [ "$host" = "$hostname" ]; then
	domain=$(hostname -d)
else
	domain=${host#*.}
fi

hostname "$hostname"
echo "$hostname" > /etc/hostname
sed -i -e "s/^127\.0\.0\.1.*/127.0.0.1\t${hostname}.${domain} ${hostname} localhost.localdomain localhost/" /etc/hosts
EOF
chmod +x /root/set_hostname
/root/set_hostname frr

# modify FRR configuration
sed -i -E '/zebra|bgp|ospf|rip|isis|pim|ldp|eigrp|static|bfd/ s/= *no/=yes/' /etc/frr/daemons
echo "service integrated-vtysh-config" > /etc/frr/vtysh.conf
chown frr:frr /etc/frr/vtysh.conf

# Remove default Alpine MOTD
truncate -s 0 /etc/motd

# run vtysh in .profile
cat > /root/.profile << 'EOF'
# ~/.profile: executed by Bourne-compatible login shells.

if [ "$BASH" ]; then
  if [ -f ~/.bashrc ]; then
    . ~/.bashrc
  fi
fi

mesg n || true

export VTYSH_PAGER="less -M -i -EFX"
vtysh
EOF

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
