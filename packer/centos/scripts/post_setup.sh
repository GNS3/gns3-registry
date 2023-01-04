#!/bin/sh
set -ex

# clear repository
dnf clean all

# clear unused space
echo 'Clearing unused space...'
dd if=/dev/zero bs=1M of=/zero >/dev/null 2>&1 || true; rm -f /zero
sync
