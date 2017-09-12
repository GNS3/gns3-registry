#!/bin/sh
#
# Copyright (C) 2015 GNS3 Technologies Inc.
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

export PATH=$PATH:/usr/share/openvswitch/scripts/

if [ ! -f "/etc/openvswitch/conf.db" ]
then
  ovs-ctl start 
  x=0
  until [ $x = "4" ]; do
    ovs-vsctl add-br br$x
    ovs-vsctl set bridge br$x datapath_type=netdev
    x=$((x+1))
  done

  if [ $MANAGEMENT_INTERFACE == 1 ]
  then
    x=1
  else
    x=0
  fi

  until [ $x = "16" ]; do
    ovs-vsctl add-port br0 eth$x
    x=$((x+1))
  done
else
  ovs-ctl start
fi


x=0
until [ $x = "4" ]; do
  ip link set dev br$x up
  x=$((x+1))
done

/bin/sh
