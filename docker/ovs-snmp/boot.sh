#!/bin/sh
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

# defaults
[ -z "$GNS3_MAX_ETHERNET" ] && GNS3_MAX_ETHERNET="eth0"
MAX_ETH=${GNS3_MAX_ETHERNET##*[[:alpha:]]}
echo $MAX_ETH
[ -z "$NUM_BR" ] && NUM_BR="1"
[ -z "$RSTP" ] && RSTP="1"
[ -z "$LLDP" ] && LLDP="1"
[ -z "$SNMP" ] && SNMP="1"

MGMT_IF="br0"; [ "$MANAGEMENT_INTERFACE" == "1" ] && MGMT_IF="eth0"
VSWITCHD_OPTS="--log-file --pidfile"


if [ ! -f "/etc/openvswitch/conf.db" ]; then
  ovsdb-tool create /etc/openvswitch/conf.db /usr/share/openvswitch/vswitch.ovsschema

  ovsdb-server --detach --remote=punix:/var/run/openvswitch/db.sock
  ovs-vswitchd --detach $VSWITCHD_OPTS
  ovs-vsctl --no-wait init

  x=0
  until [ $x -eq $NUM_BR ]; do
    ovs-vsctl add-br br$x
    ovs-vsctl set bridge br$x datapath_type=netdev
    x=$((x+1))
  done

  x=0; [ "$MANAGEMENT_INTERFACE" == "1" ] && x=1

  until [ $x -gt $MAX_ETH ]; do
    ovs-vsctl add-port br0 eth$x
    x=$((x+1))
  done
else
  ovsdb-server --detach --remote=punix:/var/run/openvswitch/db.sock
  ovs-vswitchd --detach $VSWITCHD_OPTS
fi

x=0
until [ $x -eq $NUM_BR ]; do
  if [ "$RSTP" == "1" ]; then
    rstp enable br$x
  else
    rstp disable br$x
  fi
  if [ $x -eq 0 ]; then
    [ "$RSTP_ROOT" == "1" ] && rstp primary br$x
    [ "$RSTP_ROOT" == "2" ] && rstp secondary br$x
  fi
  ip link set dev br$x up
  x=$((x+1))
done
HOSTNAME=`hostname`
echo "$HOSTNAME"

/sbin/udhcpc -R --timeout=1 --tryagain=1 -b -p /var/run/udhcpc.$MGMT_IF.pid -i $MGMT_IF -F $HOSTNAME


if [ -n "$LLDP_CHASSIS_ID" ]; then
    echo "Setting LLDP chassis ID to '$LLDP_CHASSIS_ID' "
    echo "configure system chassisid $LLDP_CHASSIS_ID" > /etc/lldpd.d/90_chassis-id.conf
else
    echo "" > /etc/lldpd.d/90_chassis-id.conf
fi

if [ "$LLDP_PID_TYPE" == "ifname" ]; then
    echo "Setting LLDP port ID type to '$LLDP_PID_TYPE' "
    echo "configure lldp portidsubtype ifname" > /etc/lldpd.d/90_portidsubtype.conf
elif [ "$LLDP_PID_TYPE" == "mac" ]; then
    echo "Setting LLDP port ID type to '$LLDP_PID_TYPE' "
    echo "configure lldp portidsubtype macaddress" > /etc/lldpd.d/90_portidsubtype.conf
else
    echo "" > /etc/lldpd.d/90_portidsubtype.conf
fi

[ "$SNMP" == "1" ] && /usr/sbin/snmpd
if [ "$LLDP" == "1" ]; then
    /usr/sbin/lldpd -x
fi

/bin/sh
