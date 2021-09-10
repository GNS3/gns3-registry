Packer for TinyCore GNS3 appliance
==================================

For building a MicroCore / TinyCore appliance.

http://tinycorelinux.net/


Packer Version Dependency
*************************

Packer versions 1.6.0 or later do not accept templates
that use the ``iso_checksum_type`` attribute.
To use these newer versions, you must delete the line
containing ``iso_checksum_type`` from core-linux.json,
core64-linux.json and tinycore-linux.json.


Clean core Linux installation
*****************************

The only added packages are:
* ipv6
* iptables
* iproute2

.. code:: bash

    packer build core-linux.json


BIRD
'''''

A build of Core with BIRD Internet Routing Daemon preinstalled.

.. code:: bash

    packer build -var-file=bird.json core64-linux.json


Openvswitch
''''''''''''

A build of Core with Openvswitch preinstalled.

.. code:: bash

    packer build -var-file=openvswitch.json core64-linux.json


Internet
''''''''
An appliance for simulating a domestic modem. eth0 as a dhcp and eth1 should be a nat interface.

.. code:: bash

    packer build -var-file=core-linux-internet.json core-linux.json


NETem
''''''

A build of Core with the NETem (Network link emulator) preinstalled.

.. code:: bash

    packer build -var-file=NETem.json core-linux.json



Tiny Core Linux installation
****************************

Tiny Core is Micro Core with a light GUI installed.

.. code:: bash

    packer build tinycore-linux.json

Firefox
'''''''''

A build of Tiny Core with Firefox preinstalled.

.. code:: bash

    packer build -var-file=tinycore-linux-firefox.json tinycore-linux.json

