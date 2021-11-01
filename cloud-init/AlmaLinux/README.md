# AlmaLinux cloud-init-data image for GNS3 virtual appliance

Generated using the following commands:

```
printf "#cloud-config\n\npassword: almalinux\nchpasswd: { expire: False }\nssh_pwauth: True\n" > user-data
printf "instance-id: almalinux\nlocal-hostname: almalinux\n" > meta-data
mkisofs -output almalinux-cloud-init-data.iso -volid cidata -joliet -rock user-data meta-data
```
