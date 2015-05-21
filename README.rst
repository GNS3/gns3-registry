GNS3-repository
================


This is the GNS3 devices repository.

You need python 3.4

Add an image
************

python3.4 gns3repository/main.py --add ~/Downloads/linux-microcore-3.4.1.img

Search an image
****************

python3.4 gns3repository/main.py --search core

Micro Core Linux:
 * 3.4.1 linux-microcore-3.4.1.img: 5f42d71b30bc682e44ccf7340e20ea7ea8967ef5
 * 4.0.2 linux-microcore-4.0.2-clean.img: 0252f2c913519c993b812325bbd553af2d77218a


Install a remote image
**************************

If the image is available from the internet you can download it:

python3.4 gns3repository/main.py --install 0252f2c913519c993b812325bbd553af2d77218a
Download http://downloads.sourceforge.net/project/gns-3/Qemu%20Appliances/linux-microcore-4.0.2-clean.img to /Users/noplay/GNS3/images/linux-microcore-4.0.2-clean.img
