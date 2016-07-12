# webterm - Networking Toolbox, Web/GUI version

This image adds the Firefox web browser to ipterm-base.
Like ipterm, the /root directory is persistent.

This appliance contains the following networking tools:

- Firefox web browser
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

## Build and publish the Images

Before ipterm-base has to be build.

```
docker build -t gns3/webterm .
docker push gns3/webterm
```
