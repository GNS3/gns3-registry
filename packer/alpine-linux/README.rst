Packer for Alpine GNS3 appliance
================================

For building an Alpine appliance.

https://alpinelinux.org/


Packer Version Dependency
*************************

Packer versions 1.6.0 or later do not accept templates
that use the ``iso_checksum_type`` attribute.
To use these newer versions, you must delete the line
containing ``iso_checksum_type`` from alpine.json.


Alpine CLI installation
***********************

The only added packages are:

* busybox-extras
* nano

.. code:: bash

    packer build alpine.json


FRR
''''

A build of Alpine with FRRouting preinstalled.

.. code:: bash

    packer build -var-file=frr.json alpine.json


Alpine GUI installation
***********************

The GUI version has XFCE4 installed.

.. code:: bash

    packer build -var-file=gui.json alpine.json

