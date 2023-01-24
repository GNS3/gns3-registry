Docker Ostinato Wireshark for GNS3
----------------------------------

This is a Dockerbuild file to create a an Alpine based container with the following installed:

Alpine Linux, Xterm, Wireshark and Ostinato

To set up remote X frame buffer display resolution open Dockerfile and edit `ENV RESOLUTION 1920x1080x24`

Thanks to Jan Kuri for the Docker container which this is based on (jkuri/alpine-xfce4)

Building the container
#######################

.. code:: bash

    docker build -t gns3/ostinato-wireshark .
