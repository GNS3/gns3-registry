FROM alpine:3.22

LABEL maintainer="developers@gns3.net"

RUN apk add --no-cache haproxy

COPY haproxy.cfg /etc/haproxy/haproxy.cfg

VOLUME ["/etc/haproxy"]

CMD ["/usr/sbin/haproxy", "-fdV", "/etc/haproxy/haproxy.cfg"]
