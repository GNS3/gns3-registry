Docker IOU
----------

**Warning not working for the moment**

This repository is a trial to make IOU work inside a docker container.
If it's work with GNS3 1.5 docker support it can allow running IOU
on any computer supporting Docker without dependencies issues.


Building the container
#######################

* Put in the directory an IOU image and name it iou.bin
* Put in the directory a valid iourc.txt file

.. code:: bash

    docker build -t iou
