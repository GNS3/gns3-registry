Packer GNS3 appliance
=====================

This directory contain the packer build script
used for some appliance in the GNS3 registry.

For building an appliance please install packer:
https://packer.io/

And after run:

.. code:: bash

    packer build template.json


If you want logs:

.. code:: bash

    PACKER_LOG=1 packer build template.json


Packer versions 1.6.0 or later do not accept templates
that use the ``iso_checksum_type`` attribute.
To use these newer versions, you must delete the line
containing ``iso_checksum_type`` from the template.json.


Conventions
************
User should be gns3 or root.
Password should be gns3.


Note for OSX users
******************

You need qemu with VNC support. If you are using homebrew you need to install it with:

.. code:: bash
    
    brew install qemu --with-sdl
