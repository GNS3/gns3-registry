#!/bin/sh
set -ex

# reset terminal attributes on login
sed -i "1s/^/$(export TERM=vt220; tput sgr0; tput smam)/" /etc/issue

# create GNS3 user
printf 'gns3\ngns3\n' | adduser --gecos 'GNS3' gns3
