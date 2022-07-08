FROM alpine:latest

RUN apk add --update openvswitch nano && rm -rf /var/cache/apk/*

RUN mkdir /var/run/openvswitch

VOLUME /etc/openvswitch/

ADD boot.sh /bin/boot.sh

CMD /bin/sh /bin/boot.sh
