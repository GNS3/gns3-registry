Packer for TinyCore GNS3 appliance
==================================

For building a MicroCore / TinyCore appliance.

http://tinycorelinux.net/

Clean core Linux installation
*****************************

The only added packages are:
* ipv6
* iptables
* iproute2

.. code:: bash

    packer build core-linux.json



Tiny Core Linux installation
****************************

Tiny Core is Micro Core with a light GUI installed.


Firefox
'''''''''

A build of Tiny Core with Firefox preinstalled.

.. code:: bash

    packer build -var-file=tinycore-linux-firefox.json tinycore-linux.json

