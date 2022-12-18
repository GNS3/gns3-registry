#!/bin/sh
# shellcheck disable=SC2034

set -e

# Export most answers for setup-alpine
set -a
KEYMAPOPTS="us us"
HOSTNAMEOPTS="-n alpine"
INTERFACESOPTS="auto lo
iface lo inet loopback

auto eth0
iface eth0 inet dhcp
    hostname alpine
"
TIMEZONEOPTS="-z UTC"
PROXYOPTS="none"
APKREPOSOPTS="-1"
SSHDOPTS="-c openssh"
NTPOPTS="-c none"
DISKOPTS="-m sys /dev/sda"
BOOT_SIZE=50
SWAP_SIZE=0
set +a

# - Answer to password question twice
# - Do not create unprivileged user
# - Select disk
# - Confirm formatting disk
setup-alpine <<EOF
root
root
no
y
EOF
