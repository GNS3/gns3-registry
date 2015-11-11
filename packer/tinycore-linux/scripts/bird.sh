# Original instructions: http://brezular.com/2011/01/20/linux-core-as-router-and-l3-switch-appliance/

set -x

tce-load -wi bird

# disable automatic interface configuration with dhcp
sudo sed -i -e '/label .*core/,/append / s/\(append .*\)/\1 nodhcp/' /mnt/sda1/boot/extlinux/extlinux.conf

# create seperate directory for bird configuration
sudo mkdir /usr/local/etc/bird
sudo mv /usr/local/etc/bird.conf /usr/local/etc/bird/bird.conf.example
sudo cp -p /usr/local/etc/bird/bird.conf.example /usr/local/etc/bird/bird.conf
sudo ln -s bird/bird.conf /usr/local/etc/bird.conf
sudo mv /usr/local/etc/bird6.conf /usr/local/etc/bird/bird6.conf.example
sudo cp -p /usr/local/etc/bird/bird6.conf.example /usr/local/etc/bird/bird6.conf
sudo ln -s bird/bird6.conf /usr/local/etc/bird6.conf
sudo sed -i -e 's/^#\( *router  *id\)/\1/' /usr/local/etc/bird/bird6.conf
sudo chown -R gns3:staff /usr/local/etc/bird

# add bird configuration to backup list
echo "usr/local/etc/bird" >> /opt/.filetool.lst
echo "usr/local/etc/bird.conf" >> /opt/.filetool.lst
echo "usr/local/etc/bird6.conf" >> /opt/.filetool.lst

#  add startup script for bird
cat >> /opt/bootlocal.sh <<'EOF'

# Boot parameter "nodhcp": network interfaces are configured statically
if grep -q -w nodhcp /proc/cmdline; then
	# This waits until all devices have registered
	/sbin/udevadm settle --timeout=10

	# configure static interface addresses and routes
	#ifconfig eth0 x.x.x.x netmask 255.255.255.0 up
	#route add default gw y.y.y.y
fi

/usr/local/sbin/bird -u gns3 -g staff
/usr/local/sbin/bird6 -u gns3 -g staff
EOF

exit 0
