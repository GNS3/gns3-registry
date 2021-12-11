# Rocky-cloud cloud-init-data image for GNS3 virtual appliance

Generated using the following commands:

```
printf "#cloud-config\n\npassword: rocky\nchpasswd: { expire: False }\nssh_pwauth: True\n" > user-data
printf "instance-id: rocky-cloud\nlocal-hostname: rocky-cloud\n" > meta-data
mkisofs -output rocky-cloud-init-data.iso -volid cidata -joliet -rock user-data meta-data
```
