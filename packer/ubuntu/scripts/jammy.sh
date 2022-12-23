#!/bin/sh
set -ex

# create GNS3 user
printf 'gns3\ngns3\n' | adduser --gecos 'GNS3' gns3
