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

This appliance is optimized to run within GNS3.
To run it locally use xhost to allow access to X and
then start the image.

```text
xhost +local:
docker run -it --ipc=host -e DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix gns3/webterm
```

## Build and publish the Images

Before ipterm-base has to be build.

```
docker build --build-arg DOCKER_REPOSITORY=gns3 -t gns3/webterm .
docker push gns3/webterm
```
