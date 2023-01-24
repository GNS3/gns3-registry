#!/bin/sh

set -e

# use serial console and remove quiet
sed -i 's/\(APPEND .*\)/\1 console=tty0 console=ttyS0,115200 earlyprintk=ttyS0,115200 consoleblank=0/' /boot/extlinux.conf
sed -i '/\(APPEND .*\)/s/[[:space:]]*quiet[[:space:]]*/ /g' /boot/extlinux.conf


# autologin on serial console
cat <<'EOF' | tee /usr/local/bin/rootlogin
#!/bin/sh
exec /bin/login -f root
EOF
chmod +x /usr/local/bin/rootlogin
#/sbin/getty -L ttyS0 115200 vt100
sed -i 's/^ttyS0.*/ttyS0::respawn:\/sbin\/getty -n -l \/usr\/local\/bin\/rootlogin -L ttyS0 115200 vt100/' /etc/inittab
