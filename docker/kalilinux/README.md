# Kali Linux

A kali linux console version for GNS3

The image include:
metasploit-framework
 * nmap
 * hydra
 * sqlmap
 * telnet
 * openssh-client
 * dnsutils
 * yersinia
 * ettercap-text-only
 * cisco-global-exploiter
 * cisco-auditing-tool
 * snmp
 * dsniff
 * dnschef
 * fping
 * hping3
 * tshark
 * python3-scapy
 * yersinia

## Build and publish the Images

First the base image has to be created:

```
docker build -t gns3/kalilinux .
docker push gns3/kalilinux    (optional)
```
