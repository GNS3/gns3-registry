#!/bin/sh
#
# Copyright (C) 2016 GNS3 Technologies Inc.
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.


mkdir -p /etc/dnsmasq

if [ ! -f /etc/dnsmasq/dnsmasq.conf ]
then
    cat > /etc/dnsmasq/dnsmasq.conf <<EOF
# dnsmasq will open tcp/udp port 53 and udp port 67 to world to help with
# dynamic interfaces (assigning dynamic ips). Dnsmasq will discard world
# requests to them, but the paranoid might like to close them and let the 
# kernel handle them:
bind-interfaces

# Dynamic range of IPs to make available to LAN pc
dhcp-range=192.168.0.50,192.168.0.240,12h

EOF
fi

echo '
 _______   __    __   ______   _______  
/       \ /  |  /  | /      \ /       \ 
$$$$$$$  |$$ |  $$ |/$$$$$$  |$$$$$$$  |
$$ |  $$ |$$ |__$$ |$$ |  $$/ $$ |__$$ |
$$ |  $$ |$$    $$ |$$ |      $$    $$/ 
$$ |  $$ |$$$$$$$$ |$$ |   __ $$$$$$$/  
$$ |__$$ |$$ |  $$ |$$ \__/  |$$ |      
$$    $$/ $$ |  $$ |$$    $$/ $$ |      
$$$$$$$/  $$/   $$/  $$$$$$/  $$/

'

echo "Edit /etc/dnsmasq/dnsmasq.conf to change the configuration"
dnsmasq --log-dhcp --no-daemon --conf-file=/etc/dnsmasq/dnsmasq.conf 
