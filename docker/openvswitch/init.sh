#!/bin/sh
#
# Copyright (C) 2024 GNS3 Technologies Inc.
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

firstrun=0
[ -f "/etc/openvswitch/conf.db" ] || firstrun=1

if [ $firstrun -ne 0 ]; then
  # create database
  ovsdb-tool create /etc/openvswitch/conf.db /usr/share/openvswitch/vswitch.ovsschema
fi

# start openvswitch daemons
mkdir -p /var/log/openvswitch /var/run/openvswitch
ovsdb-server --detach --pidfile --remote=punix:/var/run/openvswitch/db.sock \
             --log-file --verbose=off:syslog
ovs-vswitchd --detach --pidfile --log-file --verbose=off:syslog

if [ $firstrun -ne 0 ]; then
  ovs-vsctl --no-wait init

  # create br0..br3
  for intf in br0 br1 br2 br3; do
    ovs-vsctl add-br $intf
    ovs-vsctl set bridge $intf datapath_type=netdev
  done

  # add all ethernet interfaces to br0, except MANAGEMENT_INTERFACE
  [ "$MANAGEMENT_INTERFACE" = 1 ] && MANAGEMENT_INTERFACE=eth0
  sed -n 's/^ *\(eth[0-9]*\): .*/\1/p' /proc/net/dev | sort -V | \
  while read -r intf; do
    [ "$intf" = "$MANAGEMENT_INTERFACE" ] || ovs-vsctl add-port br0 "$intf"
  done
fi

# activate bridge interfaces
ovs-vsctl --bare -f table --columns=name find interface type=internal | \
while read -r intf; do
  ip link set dev "$intf" up
  ifup -f "$intf"
done
