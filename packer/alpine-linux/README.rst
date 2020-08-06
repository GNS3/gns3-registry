Packer for Alpine GNS3 appliance
================================

For building an Alpine appliance.

https://alpinelinux.org/

Alpine CLI installation
***********************

The only added packages are:

* busybox-extras
* nano

.. code:: bash

    packer build alpine_cli.json


FRR
''''

A build of Alpine with FRRouting preinstalled.

.. code:: bash

    packer build -var-file=frr.json alpine_cli.json


Alpine GUI installation
***********************

The GUI version has XFCE4 installed.

.. code:: bash

    packer build alpine_gui.json

