# ipterm - Networking Toolbox, CLI version

Based on ipterm-base it sets bash as the default command and
uses /root as a persistent directory.

This appliance contains the following networking tools:

- net-tools (basic network administration tools)
- iproute2 (advanced network administration tools)
- ping and traceroute
- curl (data transfer utility)
- host (DNS lookup utility)
- iperf3
- mtr (full screen traceroute)
- socat (utility for reading/writing from/to network connections)
- ssh client
- tcpdump
- telnet
- mtools (multicast tools msend & mreceive),
  see https://github.com/troglobit/mtools

## Build and publish the Image

Before ipterm-base has to be build.

```
docker build -t gns3/ipterm .
docker push gns3/ipterm
```
