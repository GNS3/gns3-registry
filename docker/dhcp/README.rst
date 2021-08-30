Basic DHCP server
-----------------

This container provide a basic DHCP server fro GNS3 topologies
build on top of dnsmasq.

At first startup a sample config will be write in
/etc/dnsmasq/dnsmasq.conf

You can customize the server by editing this file and restarting the container.

Build, run and publish
=======================

.. code:: bash

    docker build -t gns3/dhcp .
    docker run -i -t gns3/dhcp
    docker push gns3/dhcp
