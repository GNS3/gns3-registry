Docker Open vSwitch with SNMP for GNS3
--------------------------------------
Inspired by gns3/openvswitch
This are sources for docker image for a configurable Open vSwitch with SNMP and LLDP support.

By default, all ports will be added to br0. To have eth0 as dedicated mgmt. interface see below.

Use case examples:
- SNMP enabled switch
- test NMS / SNMP topology detection

Software 
--------
Based on alpine:latest with additional net-snmp and lldpd packets installed.

SNMP agent will listen on all interfaces, read-only community is 'public'
LLDP agent is integrated with snmpd.

Both agents can be switched on or off by the respective environment variables.

Environment variables
---------------------
Set the following variables to either 1 or 0 to start or not start the corresponding protocols / daemons:
LLDP, SNMP, RSTP default 1

Dedicated management interface
------------------------------
If MANAGEMENT_INTERFACE=1 eth0 will not be added to br0 and needs to be configured
as usual.

Number of bridges
-----------------
By default one bridge (br0) is created and all interfaces are added.
To create more bridges set NUM_BR=n (default n=1). 
Configuration of those additional bridges needs to be done manually.

RSTP
----
By default RSTP will be enabled (RSTP=1).
Use RSTP_ROOT to set bridge priority. 1 for primary root, 2 for secondary root bridge.

LLDP
----
Use LLDP_CHASSIS_ID=someName to configure chassis id.

LLDP_PID_TYPE={ifname | mac} configure the port id subtype e.g. what is used as port id.
For even more LLDP config, you can connect to a running container and edit /etc/lldpd.d/lldpd.conf 
(the folder is added as docker volume for persistence).

Helpers
-------
/bin/rstp is a wrapper for ovs-vsctl. 
Usage: rstp command [bridge]
    status      show status
    enable      enable RSTP
    disable     disable RSTP and forward BPDU
    primary     configure bridge as primary root
    secondary   configure bridge as secondary root

By default br0 will be used.

Building the container
#######################

.. code:: bash

    docker build -t gns3/ovs-snmp .
