# Debian cloud-init-data image for GNS3 virtual appliance

Generated using the following commands:

```
printf "#cloud-config\n\npassword: debian\nchpasswd: { expire: False }\nssh_pwauth: True\n" > user-data
printf "instance-id: debian\nlocal-hostname: debian\n" > meta-data
mkisofs -output debian-cloud-init-data.iso -volid cidata -joliet -rock user-data meta-data
```
