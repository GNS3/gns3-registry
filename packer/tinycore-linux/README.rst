Packer for TinyCore GNS3 appliance
==================================

For building a MicroCore / TinyCore appliance run:


Clean core Linux installation
*****************************

The only added packages are:
* ipv6
* iptables
* iproute2

.. code:: bash

    packer build core-linux.json

