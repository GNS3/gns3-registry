#!/bin/sh
set -ex

# Keep cloud networking and build DNS until package provisioning is finished.
export DEBIAN_FRONTEND=noninteractive
apt-get -y autoremove --purge netplan.io systemd-resolved
echo "network: {config: disabled}" > /etc/cloud/cloud.cfg.d/99-disable-network-config.cfg
rm -rf /etc/netplan
rm -f /etc/network/interfaces.d/50-cloud-init
resolvconf -d packer

# clear repository
apt-get clean
rm -rf /var/lib/apt/lists/*

# clear unused space
echo 'Clearing unused space...'
dd if=/dev/zero bs=1M of=/zero >/dev/null 2>&1 || true; rm -f /zero
sync
