# Kali Linux

A kali linux console version for GNS3

The image include:
* nmap
* metasploit
* sqlmap
* hydra
* telnet client
* dnsutils (dig)


## Build and publish the Images

First the base image has to be created:

```
docker build -t gns3/kalilinux .
docker push gns3/kalilinux    (optional)
```
