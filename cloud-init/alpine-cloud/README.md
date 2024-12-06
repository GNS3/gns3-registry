# Alpine-cloud cloud-init-data image for GNS3 virtual appliance

Generated using the following commands:

```
printf "#cloud-config\n\npassword: alpine\nchpasswd: { expire: False }\nssh_pwauth: True\n" > user-data
printf "instance-id: alpine-cloud\nlocal-hostname: alpine-cloud\n" > meta-data
mkisofs -output alpine-cloud-init-data.iso -volid cidata -joliet -rock user-data meta-data
```
