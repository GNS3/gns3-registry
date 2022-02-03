FROM alpine:latest
RUN apk add --no-cache nano openvswitch tcpdump net-snmp lldpd
RUN mkdir -p /run/openvswitch && mkdir -p /var/log/openvswitch
COPY snmpd.conf /etc/snmp/snmpd.conf
COPY lldpd.conf /etc/lldpd.d/lldpd.conf
COPY boot.sh /bin/boot.sh
RUN chmod a+x /bin/boot.sh

COPY rstp /bin/rstp
RUN chmod a+x /bin/rstp

VOLUME /etc/openvswitch/
VOLUME /etc/lldpd.d/

CMD ["/bin/boot.sh"]
