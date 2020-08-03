Packer for Alpine GNS3 appliance
================================

For building an Alpine appliance.

https://alpinelinux.org/

CLI Linux installation
**********************

The only added packages are:
* busybox-extras
* nano

.. code:: bash

    packer build alpine_cli.json


GUI Linux installation
**********************

The GUI version has XFCE4 installed.

.. code:: bash

    packer build alpine_gui.json

