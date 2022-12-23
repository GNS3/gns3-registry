#!/usr/bin/env sh

set -ex

printf "gns3\ngns3\n" | useradd -c "gns3" -G wheel gns3
