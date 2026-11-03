#!/bin/sh

set -e

# add community repository
sed -i 's/^#\s*\(.*\/v.*\/community\)$/\1/' /etc/apk/repositories
apk update

# install packages
apk add xorg-server xf86-input-libinput xinit mesa-dri-gallium \
    eudev udev-init-scripts udev-init-scripts-openrc \
    lxdm xfwm4 xfdesktop xfce4-appfinder xfce4-session xfce4-settings \
    xfce4-terminal dillo thunar exo adwaita-icon-theme ttf-dejavu

rc-update del mdev sysinit
rc-update del hwdrivers sysinit
rc-update add udev sysinit
rc-update add udev-trigger sysinit
rc-update add udev-settle sysinit
rc-update add udev-postmount default

# configure packages
sed -i 's/^.*session=.*/session=\/usr\/bin\/startxfce4/' /etc/lxdm/lxdm.conf
echo "/sbin/poweroff" >> /etc/lxdm/PreShutdown
ln -s /usr/bin/dillo /usr/local/bin/firefox
rc-update add dbus
rc-update add lxdm

# create user account
adduser -D -g "Linux User" user
passwd -u user
sed -i 's/^#*[[:space:]]*autologin=.*/autologin=user/' /etc/lxdm/lxdm.conf
