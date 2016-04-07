FROM alpine:3.3
MAINTAINER developers@gns3.net

RUN apk add --update dnsmasq && rm -rf /var/cache/apk/*

VOLUME /etc/dnsmasq
COPY boot.sh .

CMD /bin/sh boot.sh
