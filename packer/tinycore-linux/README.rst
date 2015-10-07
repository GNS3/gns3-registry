Packer for TinyCore GNS3 appliance
==================================

For building a TinyCore V6.4 appliance run:

.. code:: bash

    packer build -var-file=tc-6.4.json tinycore-linux.json


Likewise, to build a TinyCore V4.7.7 appliance run:

.. code:: bash

    packer build -var-file=tc-4.7.7.json tinycore-linux.json
