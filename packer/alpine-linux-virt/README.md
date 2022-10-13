# Packer for Alpine (Virt) GNS3 appliance

This is the bare version of `Alpine Linux` installed from iso, no extra package added.

Build in 1m12s on `macOS Monterey`.

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
