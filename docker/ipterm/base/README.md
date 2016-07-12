# ipterm-base - Networking Toolbox, base image

This is a base image, it's not intended for direct use.

This image contains the following networking tools:

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

```
docker build -t gns3/ipterm-base .
docker push gns3/ipterm-base    (optional)
```
