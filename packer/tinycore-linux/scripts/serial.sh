# Add serial console support

set -x

# Boot configuration
# Serial interface is secondary console, the vga console remains main console
# To change that, exchange the two 'console=' boot parameter
sudo sed -i -e '1 i serial 0 38400' -e '/label .*core/,/append / s/\(append .*\)/\1 console=ttyS0,38400 console=tty0/' /mnt/sda1/boot/extlinux/extlinux.conf

# /etc/inittab
sudo sed -i -e '/tty6/ a ttyS0::respawn:/sbin/getty 38400 ttyS0 xterm' /etc/inittab

# /etc/securetty
sudo sed -i -e 's/^# *ttyS0/ttyS0/' /etc/securetty

# reload inittab on startup
sudo sed -i -e '/^\/opt\/bootlocal/ i' -e '/^\/opt\/bootlocal/ i # reload inittab' -e '/^\/opt\/bootlocal/ i kill -HUP 1' -e '/^\/opt\/bootlocal/ i' /opt/bootsync.sh

# add modified files to backup list
echo 'etc/inittab' >> /opt/.filetool.lst
echo 'etc/securetty' >> /opt/.filetool.lst
