# Packer for Alpine (Virt) GNS3 appliance

This is the bare version of `Alpine Linux` installed from iso, no extra package added.

Build in 1m12s on `macOS Monterey`.

### Linux (untested)

```bash
packer build alpine.json
```

> :information_source: Uses `tcg` QEMU accelerator.


### macOS (tested)

```bash
packer build -var-file macos.json alpine.json
```

> :information_source: Uses `hvf` QEMU accelerator. Actually much much faster than the default one, `packer` will fail on `macOS` without `hvf` (timing issue).
