# Ubuntu - Programming Toolbox

This appliance contains the following networking tools:

- net-tools (basic network administration tools)
- ping
- ssh client
- telnet
- Python 2
- Python 3
- Perl
- Go
- PHP

The /root folder is mounted by default

## Build and publish the Images

First the base image has to be created:

```
docker build -t gns3/python-go-perl-php:latest .
docker push gns3/python-go-perl-php:latest    (optional)
```
