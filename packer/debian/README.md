# Packer for Debian based GNS3 appliances

## Debian

Provisioning preserves upstream DNS through the switch to `resolvconf`.
Cloud networking and the temporary build DNS entry are removed only after
the appliance packages have been installed. Repository update failures abort
the build rather than continuing with incomplete package indexes.

```
packer build debian.json
```

This builds both amd64 and arm64 images. To select one architecture:

```
packer build -only=amd64 debian.json
packer build -only=arm64 debian.json
```

The arm64 builder uses Debian's arm64 cloud image, `qemu-system-aarch64`,
and software emulation. It requires aarch64 UEFI firmware, defaulting to
`/usr/share/AAVMF/AAVMF_CODE.fd` and `/usr/share/AAVMF/AAVMF_VARS.fd`.
Override `efi_firmware_code` and `efi_firmware_vars` for other firmware paths.
Its cloud-init ISO is generated from `user-data` and `meta-data` using
`xorriso` or another Packer-supported ISO creation tool.

Outputs are written to `output-amd64` and `output-arm64`. After the build,
each disk is renamed using the installed Debian point release from
`/etc/debian_version` and the architecture, for example
`debian-13.2-amd64.qcow2`. Setup scripts can write an application version to
`/tmp/packer-app-version` to include it as well; `bird2.sh` records the BIRD
version, producing e.g. `debian-13.2-bird2-2.17.1-arm64.qcow2`. Run Packer
from this directory, since the version file is downloaded to the current
directory before renaming.

## BIRDv2

A build of Debian with BIRD Internet Routing Daemon v2 preinstalled.

```
packer build -var-file=bird2.json debian.json
```

This builds both amd64 and arm64 images. To select one architecture:

```
packer build -only=amd64 -var-file=bird2.json debian.json
packer build -only=arm64 -var-file=bird2.json debian.json
```
