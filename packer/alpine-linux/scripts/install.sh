#!/bin/sh

set -e

export HOSTNAMEOPTS="-n alpine"
export KEYMAPOPTS="us us"
export INTERFACESOPTS="auto lo
iface lo inet loopback

auto eth0
iface eth0 inet dhcp
"
export TIMEZONEOPTS="-z UTC"
export PROXYOPTS="none"
export APKREPOSOPTS="-1"
export SSHDOPTS="-c openssh"
export NTPOPTS="-c none"
export BOOT_SIZE=50
export SWAP_SIZE=0

# Answer to password question twice and yes to format drive
setup-alpine <<EOF
root
root
sda
sys
y
EOF
