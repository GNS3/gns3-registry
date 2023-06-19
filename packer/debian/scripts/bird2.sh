#!/bin/sh
set -ex

# Install bird2 (plus telnet)
export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get -y install bird2 inetutils-telnet
chmod g+rw /etc/bird
chmod g+rw /etc/bird/*.conf

# Use traditional style interface names eth*
sed -i '/^GRUB_CMDLINE_LINUX=/ s/"$/ net.ifnames=0"/' /etc/default/grub
update-grub
sed -i 's/\bens4\b/eth0/g' /etc/network/interfaces

# Enable IP forwarding
cat > /etc/sysctl.d/50-ip_forwarding.conf << 'EOF'
# /etc/sysctl.d/50-ip_forwarding.conf - Enable IP forwarding

# Uncomment the next line to enable packet forwarding for IPv4
net.ipv4.ip_forward=1

# Uncomment the next line to enable packet forwarding for IPv6
#  Enabling this option disables Stateless Address Autoconfiguration
#  based on Router Advertisements for this host
net.ipv6.conf.all.forwarding=1
EOF

# Load dummy module
echo dummy >> /etc/modules

# create GNS3 user
printf 'gns3\ngns3\n' | adduser --gecos 'GNS3' gns3
printf '# User rules for gns3\ngns3 ALL=(ALL) NOPASSWD:ALL\n' > /etc/sudoers.d/50-gns3-user

# Make BIRD easier to use
usermod -a -G bird gns3
cat >> /home/gns3/.profile << 'EOF'

# BIRD
alias birdc='/usr/sbin/birdc'
alias birdcl='/usr/sbin/birdcl'
cd /etc/bird
EOF

# Sample screen startup file
cat > /home/gns3/.screenrc << 'EOF'
# Disable startup message
startup_message off

# use bash as default shell
defshell -bash

# Set escape key to Ctrl+j
#escape ^Jj

# Start at window 1
#bind c screen 1
#bind ^c screen 1
#bind 0 select 10
#screen 1
EOF
chown gns3:gns3 /home/gns3/.screenrc
