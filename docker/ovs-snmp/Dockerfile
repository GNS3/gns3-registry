FROM alpine:3.22

LABEL maintainer="developers@gns3.net"

RUN apk add --no-cache \
    nano \
    openvswitch \
    tcpdump \
    net-snmp \
    lldpd

RUN mkdir -p /run/openvswitch /var/log/openvswitch

COPY snmpd.conf /etc/snmp/snmpd.conf
COPY lldpd.conf /etc/lldpd.d/lldpd.conf

COPY rstp /bin/rstp
COPY boot.sh /bin/boot.sh
RUN chmod +x /bin/rstp /bin/boot.sh

VOLUME ["/etc/openvswitch", "/etc/lldpd.d"]

CMD ["/bin/boot.sh"]
