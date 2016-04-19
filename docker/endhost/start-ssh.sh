#!/bin/sh

ssh-keygen -t rsa -b 4096 -f /etc/ssh/ssh_host_rsa_key -N ''
ssh-keygen -t dsa -b 1024 -f /etc/ssh/ssh_host_dsa_key -N ''
ssh-keygen -t ecdsa -b 256 -f /etc/ssh/ssh_host_ecdsa_key -N ''
ssh-keygen -t ed25519 -b 256 -f /etc/ssh/ssh_host_ed25519_key -N ''
ssh-keygen -f /root/.ssh/id_rsa -N ''
echo 'root:gns3' | chpasswd
sed -i "s/#PermitRootLogin prohibit-password/PermitRootLogin yes/" /etc/ssh/sshd_config
/usr/sbin/sshd && echo "SSHD started: $(pgrep sshd)"
