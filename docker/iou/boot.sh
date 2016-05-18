#!/bin/bash

export IOURC=/images/iourc.txt

dd if=/dev/zero bs=4 count=1 of=/etc/hostid

cd /data
python3 /netmap.py 

/bin/iouyap 513 &


/images/iou.bin 1 || /bin/bash -i  

