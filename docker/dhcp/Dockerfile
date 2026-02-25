FROM alpine:3.22

LABEL maintainer="developers@gns3.net"

RUN apk add --no-cache dnsmasq

VOLUME ["/etc/dnsmasq"]

COPY boot.sh /boot.sh
RUN chmod +x /boot.sh

CMD ["/bin/sh", "/boot.sh"]
