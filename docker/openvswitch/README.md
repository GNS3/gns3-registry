# Docker Open vSwitch for GNS3

This creates a container for using Open vSwitch in GNS3.

This container supports ethernet interfaces and comes
with bridges from br0 to br3.

By default, all interfaces are connected to br0.

If you set the `MANAGEMENT_INTERFACE` environment variable to
an interface name, that interface will not be connected to br0.


## Building the container

```
docker build -t gns3/openvswitch .
```
