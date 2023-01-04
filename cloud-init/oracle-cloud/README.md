# Oracle-cloud cloud-init-data image for GNS3 virtual appliance

Generated using the following commands:

```
printf "#cloud-config\n\npassword: oracle\nchpasswd: { expire: False }\nssh_pwauth: True\n" > user-data
printf "instance-id: oracle-cloud\nlocal-hostname: oracle-cloud\n" > meta-data
mkisofs -output oracle-cloud-init-data.iso -volid cidata -joliet -rock user-data meta-data
```
