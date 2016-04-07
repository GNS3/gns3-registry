FROM ubuntu:14.04

ENV DEBIAN_FRONTEND noninteractive  

RUN dpkg --add-architecture i386

RUN apt-get update

RUN apt-get install python3

RUN apt-get install -y lib32z1
RUN apt-get install -y libssl1.0.0
RUN apt-get install -y 'libssl1.0.0:i386'
RUN ln -s /lib/i386-linux-gnu/libcrypto.so.1.0.0 /lib/i386-linux-gnu/libcrypto.so.4

VOLUME /data

ADD iouyap /bin
RUN chmod 700 /bin/iouyap

RUN mkdir /images
ADD iourc.txt /images
ADD iou.bin /images
RUN chmod 700 /images/iou.bin

ADD boot.sh /
ADD netmap.py /

ENV HOSTNAME=gns3vm

CMD /bin/bash ./boot.sh
