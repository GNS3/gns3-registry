# Packer for Debian based GNS3 appliances

## Packer Version Dependency

Packer versions 1.6.0 or later do not accept templates
that use the `iso_checksum_type` attribute.
To use these newer versions, you must delete the line
containing `iso_checksum_type` from debian.json.


## Generate debian-cloud-init-data image

debian-cloud-init-data can be generated with the following commands:

```
printf "#cloud-config\n\npassword: debian\nchpasswd: { expire: False }\nssh_pwauth: True\n" > user-data
printf "instance-id: debian\nlocal-hostname: debian\n" > meta-data
mkisofs -output debian-cloud-init-data.iso -volid cidata -joliet -rock user-data meta-data
```

## Debian CLI

```
packer build debian.json
```

## Debian-11 CLI

```
packer build -var-file=debian-11.json debian.json
```

## BIRDv2

A build of Debian with BIRD Internet Routing Daemon v2 preinstalled.

```
packer build -var-file=bird2.json debian.json
```
