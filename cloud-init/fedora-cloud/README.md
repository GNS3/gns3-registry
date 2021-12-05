# Fedora-cloud cloud-init-data image for GNS3 virtual appliance

Generated using the following commands:

```
printf "#cloud-config\n\npassword: fedora\nchpasswd: { expire: False }\nssh_pwauth: True\n" > user-data
printf "instance-id: fedora-cloud\nlocal-hostname: fedora-cloud\n" > meta-data
mkisofs -output fedora-cloud-init-data.iso -volid cidata -joliet -rock user-data meta-data
```
