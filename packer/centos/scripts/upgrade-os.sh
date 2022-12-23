#!/bin/sh
set -ex

# clear repository
dnf clean all

dnf update -y
