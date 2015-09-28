#Enable a terminal on serial port
echo "ttyS0::respawn:/sbin/getty -L ttyS0 115200 vt1003" >> etc/inittab

apk add linux-virtgrsec
apk del linux-grsec
rm -Rf /lib/firmware
rm -rf /var/cache/apk/*

# Write 0
dd if=/dev/zero of=/zero ; rm -f /zero
