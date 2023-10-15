# Packer for Alpine (Virt) GNS3 appliance

This is the bare version of `Alpine Linux` installed from iso, no extra package added. From `v3.18.4`, the image file goes from 100MB to 200MB, and is using `qcow2` format to allow compression.

Build in 1m14s on `macOS Monterey`.

### Linux (tested)

```bash
packer build alpine.json
```

> :information_source: Uses `kvm` QEMU accelerator.


### macOS (tested)

```bash
packer build -var-file macos.json alpine.json
```

> :information_source: Uses `hvf` QEMU accelerator. `Packer` will fail on `macOS` without `hvf` (timing issue).

See:
- https://wiki.alpinelinux.org/wiki/Alpine_setup_scripts#setup-disk
- https://wiki.alpinelinux.org/wiki/Enable_Serial_Console_on_Boot#Example_.2Fboot.2Fextlinux.conf
- https://wiki.alpinelinux.org/wiki/Install_to_disk
- https://www.packer.io/plugins/builders/qemu
