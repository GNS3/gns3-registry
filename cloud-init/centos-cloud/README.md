# Centos-cloud cloud-init-data image for GNS3 virtual appliance

Generated using the following commands:

```
printf "#cloud-config\n\npassword: centos\nchpasswd: { expire: False }\nssh_pwauth: True\n" > user-data
printf "instance-id: centos-cloud\nlocal-hostname: centos-cloud\n" > meta-data
mkisofs -output centos-cloud-init-data.iso -volid cidata -joliet -rock user-data meta-data
```
