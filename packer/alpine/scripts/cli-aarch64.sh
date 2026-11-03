#!/bin/sh

set -e

sed -i '/^GRUB_CMDLINE_LINUX_DEFAULT=/s/"$/ console=tty0 console=ttyAMA0,115200 consoleblank=0"/' /etc/default/grub
grub-mkconfig -o /boot/grub/grub.cfg

cat > /usr/local/bin/rootlogin <<'EOF'
#!/bin/sh
exec /bin/login -f root
EOF
chmod +x /usr/local/bin/rootlogin
sed -i '/^ttyAMA0:/d' /etc/inittab
echo 'ttyAMA0::respawn:/sbin/getty -n -l /usr/local/bin/rootlogin -L ttyAMA0 115200 vt100' >> /etc/inittab
