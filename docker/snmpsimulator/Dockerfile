FROM debian
RUN apt-get update
RUN apt-get install -qqy snmpsim
RUN useradd snmp
CMD snmpsimd --agent-udpv4-endpoint=0.0.0.0:1161 --process-user=snmp --process-group=snmp
