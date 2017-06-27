# Ubuntu - Network Automation Toolbox

This appliance contains the following network automation tools:

- Netmiko
- NAPALM
- Pyntc
- Ansible

The /root folder is mount by default

## Build and publish the Images

First the base image has to be created:

```
docker build -t gns3/network_autmation:latest .
docker push gns3/network_autmation:latest    (optional)
```
