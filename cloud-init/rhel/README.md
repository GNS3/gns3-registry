# cloud-init image for loading with Red Hat Enterprise Linux KVM Guest Image

Generated using the following commands:
```
echo -e "#cloud-config\npassword: redhat\nchpasswd: { expire: False }\nssh_pwauth: True" > user-data
echo -e "instance-id: rhel\nlocal-hostname: localhost" > meta-data
mkisofs -output "rhel-cloud-init.iso" -volid cidata -joliet -rock {user-data,meta-data}
```

Adaptation to RHEL from Ubuntu: https://github.com/asenci/gns3-ubuntu-cloud-init-data.

Moved from old store: https://gitlab.com/neyder/rhel-cloud-init/
