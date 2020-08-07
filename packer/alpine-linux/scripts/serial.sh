# use serial console
sed -i 's/\(APPEND .*\)/\1 console=ttyS0/' /boot/extlinux.conf

# autologin on serial console
sed -i 's/^ttyS0.*/ttyS0::respawn:\/bin\/login -f root/' /etc/inittab
