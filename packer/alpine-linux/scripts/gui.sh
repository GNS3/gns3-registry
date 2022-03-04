# add community repository
sed -i 's/^#\s*\(.*\/v.*\/community\)$/\1/' /etc/apk/repositories
apk update

# install packages
setup-xorg-base lxdm xfwm4 xfdesktop xfce4-appfinder xfce4-session xfce4-settings xfce4-terminal dillo thunar exo adwaita-icon-theme ttf-dejavu xf86-video-qxl

# configure packages
sed -i 's/^.*session=.*/session=\/usr\/bin\/startxfce4/' /etc/lxdm/lxdm.conf
echo "/sbin/poweroff" >> /etc/lxdm/PreShutdown
ln -s /usr/bin/dillo /usr/local/bin/firefox
rc-update add dbus
rc-update add lxdm

# create user account
adduser -D -g "Linux User" user
passwd -u user
