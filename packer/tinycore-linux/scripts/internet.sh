set -x

# Enable NAT
echo "iptables -t nat -A POSTROUTING -o eth1 -j MASQUERADE" >> /opt/bootlocal.sh
echo "iptables -A FORWARD -i eth1 -o eth0 -m state --state RELATED,ESTABLISHED -j ACCEPT" >> /opt/bootlocal.sh
echo "iptables -A FORWARD -i eth0 -o eth1 -j ACCEPT" >> /opt/bootlocal.sh


tce-load -wi dnsmasq

# Setup DHCP
# A random IP range is choose at startup allowing user to put multiple access links
cat > setup_dhcp_and_ip.sh << 'EOF2'
#!/bin/sh

killall udhcpc
killall udhcpd
killall dnsmasq 

udhcpc -i eth1

IP=$((RANDOM%253+1))

ifconfig eth0 172.16.$IP.1 netmask 255.255.255.0 up

echo "expand-hosts" >> /etc/dnsmasq.conf
echo "no-negcache" >> /etc/dnsmasq.conf
echo "dhcp-authoritative" >> /etc/dnsmasq.conf
echo "dhcp-leasefile=/tmp/dhcp.leases" >> /etc/dnsmasq.conf
echo "dhcp-range=172.16.$IP.2,172.16.$IP.254,12h" >> /etc/dnsmasq.conf
echo "# Netmask" >> /etc/dnsmasq.conf
echo "dhcp-option=1,255.255.255.0" >> /etc/dnsmasq.conf
echo "# Route" >> /etc/dnsmasq.conf
echo "dhcp-option=3,172.16.$IP.1" >> /etc/dnsmasq.conf

dnsmasq
EOF2

sudo mv setup_dhcp_and_ip.sh /sbin/setup_dhcp_and_ip.sh
sudo chmod 700 /sbin/setup_dhcp_and_ip.sh
sudo chown root /sbin/setup_dhcp_and_ip.sh

echo '/sbin/setup_dhcp_and_ip.sh' >> /opt/bootlocal.sh
echo 'etc/dnsmasq.conf' >> /opt/.filetool.lst
echo 'sbin/setup_dhcp_and_ip.sh' >> /opt/.filetool.lst

