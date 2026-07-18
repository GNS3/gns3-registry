# Ubuntu - Networking Toolbox

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

The /root folder is mounted by default

## Build and publish the Images

First the base image has to be created:

```
docker build -t gns3/ubuntu:noble .
docker push gns3/ubuntu:nobel (optional)
```
