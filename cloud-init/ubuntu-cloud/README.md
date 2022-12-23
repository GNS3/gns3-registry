# Ubuntu-cloud cloud-init-data image for GNS3 virtual appliance

Generated using the following commands:

```
printf "#cloud-config\n\npassword: ubuntu\nchpasswd: { expire: False }\nssh_pwauth: True\n" > user-data
printf "instance-id: ubuntu-cloud\nlocal-hostname: ubuntu-cloud\n" > meta-data
mkisofs -output ubuntu-cloud-init-data.iso -volid cidata -joliet -rock user-data meta-data
```
