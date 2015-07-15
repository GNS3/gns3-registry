GNS3-registry
================


This is the GNS3 devices registry.

You need python 3.4 installed

Add an image
************

.. code:: bash
    
    bin/gns3-get --add ~/Downloads/linux-microcore-3.4.1.img

Search an image
****************

.. code:: bash

    bin/gns3-get --search core

    Micro Core Linux:
     * hda_disk_image:
       * 3.4.1 linux-microcore-3.4.1.img: fa2ec4b1fffad67d8103c3391bbf9df2
       * 4.0.2 linux-microcore-4.0.2-clean.img: e13d0d1c0b3999ae2386bba70417930c

       
Install a remote image
**************************

If the image is available from the internet you can download and install it:

.. code:: bash

    bin/gns3-get --install e13d0d1c0b3999ae2386bba70417930c
    
    Download http://downloads.sourceforge.net/project/gns-3/Qemu%20Appliances/linux-microcore-4.0.2-clean.img to /Users/noplay/GNS3/images/linux-microcore-4.0.2-clean.img
