Docker Open vSwitch for GNS3
------------------------------

This make a container for using Open vSwitch in GNS3 1.5 and later.

This container support 16 ethernet interface and is shipped with 
bridge from br0 to br3.

By default all interface are connected to the br0.

If you set the environnement variable MANAGEMENT_INTERFACE to 1
eth0 will not be attach to the container.

### Image based on the latest openvswitch2.8 installed on Alpine:edge


Building the container
#######################

.. code:: bash

    docker build -t gns3/openvswitch28 .
