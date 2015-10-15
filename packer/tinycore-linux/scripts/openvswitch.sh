# Original instructions: http://brezular.com/2011/09/03/openvswich-creating-and-submitting-openvswitch-extension-to-microcore-repository/

set -x


# We need gcc because it contain some dependencies of openvswitch
tce-load -wi gcc.tcz

tce-load -wi openvswitch-3.16.6-tinycore64


sudo modprobe openvswitch

echo "modprobe openvswitch" >> /opt/bootlocal.sh
echo "modprobe 8021q" >> /opt/bootlocal.sh

sudo mkdir -p /usr/local/etc/openvswitch/
sudo ovsdb-tool create /usr/local/etc/openvswitch/conf.db /usr/local/etc/openvswitch/vswitchd/vswitch.ovsschema

echo "/usr/local/etc/openvswitch/" >> /opt/.filetool.lst
sudo chgrp -R staff /usr/local/etc/openvswitch/

echo "/usr/local/sbin/ovsdb-server --remote=punix:/usr/local/var/run/openvswitch/db.sock --remote=db:Open_vSwitch,Open_vSwitch,manager_options --private-key=db:Open_vSwitch,SSL,private_key --certificate=db:Open_vSwitch,SSL,certificate --bootstrap-ca-cert=db:Open_vSwitch,SSL,ca_cert --pidfile --detach" >> /opt/bootlocal.sh

echo "/usr/local/bin/ovs-vsctl --no-wait init" >> /opt/bootlocal.sh

echo "/usr/local/sbin/ovs-vswitchd --pidfile --detach" >> /opt/bootlocal.sh

sudo /opt/bootlocal.sh

sudo ovs-vsctl add-br br0

echo 'for interface in `ip link | cut -d " " -f2 | grep "eth" | sed "s/:$//"`;do ovs-vsctl add-port br0 $interface; done'  >> /opt/bootlocal.sh

exit 0
