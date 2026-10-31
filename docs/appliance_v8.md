# JSON schema validating a GNS3 appliance

JSON Schema missing a description, provide it using the `description` key in the root of the JSON document.

### Type: `object`

| Property | Type | Required | Possible values | Deprecated | Default | Description | Examples |
| -------- | ---- | -------- | --------------- | ---------- | ------- | ----------- | -------- |
| appliance_id | `string` | ✅ | [`^[a-fA-F0-9]{8}-[a-fA-F0-9]{4}-[a-fA-F0-9]{4}-[a-fA-F0-9]{4}-[a-fA-F0-9]{12}$`](https://regex101.com/?regex=%5E%5Ba-fA-F0-9%5D%7B8%7D-%5Ba-fA-F0-9%5D%7B4%7D-%5Ba-fA-F0-9%5D%7B4%7D-%5Ba-fA-F0-9%5D%7B4%7D-%5Ba-fA-F0-9%5D%7B12%7D%24) |  |  |  |  |
| name | `string` | ✅ | string |  |  |  |  |
| category | Missing type | ✅ | [categories](#categories) |  |  |  |  |
| description | `string` | ✅ | string |  |  |  |  |
| vendor_name | `string` | ✅ | string |  |  |  |  |
| vendor_url | `string` | ✅ | Format: [`uri`](https://json-schema.org/understanding-json-schema/reference/string#built-in-formats) |  |  |  |  |
| product_name | `string` | ✅ | string |  |  |  |  |
| registry_version | `None` | ✅ | `8` |  |  |  |  |
| status | `None` | ✅ | `stable` `experimental` `broken` |  |  |  |  |
| maintainer | `string` | ✅ | string |  |  |  |  |
| maintainer_email | `string` | ✅ | Format: [`email`](https://json-schema.org/understanding-json-schema/reference/string#built-in-formats) |  |  |  |  |
| settings | `array` | ✅ | object |  |  |  |  |
| settings[].name | `string` |  | string |  |  |  |  |
| settings[].default | `boolean` |  | boolean |  |  |  |  |
| settings[].inherit_default_properties | `boolean` |  | boolean |  | `"true"` |  |  |
| settings[].template_type | `None` | ✅ | `docker` `iou` `dynamips` `qemu` |  |  |  |  |
| settings[].template_properties | `object` | ✅ | [docker_properties](#docker_properties) or [dynamips_properties](#dynamips_properties) or [iou_properties](#iou_properties) or [qemu_properties](#qemu_properties) |  |  |  |  |
| tags | `array` |  | string |  |  |  |  |
| vendor_logo_url | `string` |  | Format: [`uri`](https://json-schema.org/understanding-json-schema/reference/string#built-in-formats) |  |  |  |  |
| documentation_url | `string` |  | Format: [`uri`](https://json-schema.org/understanding-json-schema/reference/string#built-in-formats) |  |  |  |  |
| product_url | `string` |  | Format: [`uri`](https://json-schema.org/understanding-json-schema/reference/string#built-in-formats) |  |  |  |  |
| availability | `None` |  | `free` `with-registration` `free-to-try` `service-contract` |  |  |  |  |
| installation_instructions | `string` |  | string |  |  |  |  |
| usage | `string` |  | string |  |  |  |  |
| netmiko_device_type | `string` |  | [`^[a-z0-9_]+$`](https://regex101.com/?regex=%5E%5Ba-z0-9_%5D%2B%24) |  |  |  |  |
| default_username | `string` |  | string |  |  |  |  |
| default_password | `string` |  | string |  |  |  |  |
| symbol | `string` |  | string |  |  |  |  |
| images | `array` |  | object |  |  |  |  |
| images[].filename and/or images[].version and/or images[].md5sum and/or images[].checksum and/or images[].checksum_type and/or images[].filesize and/or images[].download_url and/or images[].direct_download_url and/or images[].compression and/or images[].compression_target | `None`, `integer`, `string` |  |  |  |  |  |  |
| versions | `array` |  | object |  |  |  |  |
| versions[].name | `string` | ✅ | string |  |  |  |  |
| versions[].settings | `string` |  | string |  |  |  |  |
| versions[].category | Missing type |  | [categories](#categories) |  |  |  |  |
| versions[].installation_instructions | `string` |  | string |  |  |  |  |
| versions[].usage | `string` |  | string |  |  |  |  |
| versions[].default_username | `string` |  | string |  |  |  |  |
| versions[].default_password | `string` |  | string |  |  |  |  |
| versions[].symbol | `string` |  | string |  |  |  |  |
| versions[].images | `object` |  | object |  |  |  |  |
| versions[].images.kernel_image | `string` |  | string |  |  |  |  |
| versions[].images.initrd | `string` |  | string |  |  |  |  |
| versions[].images.image | `string` |  | string |  |  |  |  |
| versions[].images.bios_image | `string` |  | string |  |  |  |  |
| versions[].images.hda_disk_image | `string` |  | string |  |  |  |  |
| versions[].images.hdb_disk_image | `string` |  | string |  |  |  |  |
| versions[].images.hdc_disk_image | `string` |  | string |  |  |  |  |
| versions[].images.hdd_disk_image | `string` |  | string |  |  |  |  |
| versions[].images.cdrom_image | `string` |  | string |  |  |  |  |


---

# Definitions

## categories

No description provided for this model.

#### Type: `object(?)`

**Possible Values:** `router` or `multilayer_switch` or `switch` or `firewall` or `guest`

## docker_properties

No description provided for this model.

#### Type: `object`

> ⚠️ Additional properties are not allowed.

| Property | Type | Required | Possible values | Deprecated | Default | Description | Examples |
| -------- | ---- | -------- | --------------- | ---------- | ------- | ----------- | -------- |
| image | `string` | ✅ | string |  |  |  |  |
| name | `string` |  | string |  |  |  |  |
| category | Missing type |  | [categories](#categories) |  |  |  |  |
| default_name_format | `string` |  | string |  |  |  |  |
| usage | `string` |  | string |  |  |  |  |
| symbol | `string` |  | string |  |  |  |  |
| adapters | `integer` |  | integer |  |  |  |  |
| start_command | `string` |  | string |  |  |  |  |
| environment | `string` |  | string |  |  |  |  |
| console_type | `None` |  | `telnet` `vnc` `http` `https` `none` `docker_exec` |  |  |  |  |
| console_http_port | `integer` |  | integer |  |  |  |  |
| console_http_path | `string` |  | string |  |  |  |  |
| console_resolution | `string` |  | [`^[0-9]+x[0-9]+$`](https://regex101.com/?regex=%5E%5B0-9%5D%2Bx%5B0-9%5D%2B%24) |  |  |  |  |
| extra_hosts | `string` |  | string |  |  |  |  |
| extra_volumes | `array` |  | array |  |  |  |  |
| custom_adapters | `array` |  | object |  |  |  |  |
| custom_adapters[].adapter_number | `integer` | ✅ | integer |  |  |  |  |
| custom_adapters[].port_name | `string` |  | string |  |  |  |  |
| custom_adapters[].adapter_type | `string` |  | `e1000` `i82550` `i82551` `i82557a` `i82557b` `i82557c` `i82558a` `i82558b` `i82559a` `i82559b` `i82559c` `i82559er` `i82562` `i82801` `igb` `ne2k_pci` `pcnet` `rtl8139` `virtio` `virtio-net-pci` `vmxnet3` |  |  |  |  |
| custom_adapters[].mac_address | `string` |  | [`^([0-9a-fA-F]{2}[:]){5}([0-9a-fA-F]{2})$`](https://regex101.com/?regex=%5E%28%5B0-9a-fA-F%5D%7B2%7D%5B%3A%5D%29%7B5%7D%28%5B0-9a-fA-F%5D%7B2%7D%29%24) |  |  |  |  |
| extra_configs | `array` |  | object |  |  |  |  |
| extra_configs[].target | `string` | ✅ | string |  |  |  |  |
| extra_configs[].content | `string` |  | string |  |  |  |  |

## iou_properties

No description provided for this model.

#### Type: `object`

> ⚠️ Additional properties are not allowed.

| Property | Type | Required | Possible values | Deprecated | Default | Description | Examples |
| -------- | ---- | -------- | --------------- | ---------- | ------- | ----------- | -------- |
| name | `string` |  | string |  |  |  |  |
| category | Missing type |  | [categories](#categories) |  |  |  |  |
| default_name_format | `string` |  | string |  |  |  |  |
| usage | `string` |  | string |  |  |  |  |
| symbol | `string` |  | string |  |  |  |  |
| ethernet_adapters | `integer` |  | integer |  |  |  |  |
| serial_adapters | `integer` |  | integer |  |  |  |  |
| ram | `integer` |  | integer |  |  |  |  |
| nvram | `integer` |  | integer |  |  |  |  |
| startup_config | `string` |  | string |  |  |  |  |

## dynamips_slot

No description provided for this model.

#### Type: `object(?)`

**Possible Values:** `C2600-MB-2FE` or `C2600-MB-1E` or `PA-A1` or `PA-8E` or `C1700-MB-1FE` or `PA-8T` or `PA-2FE-TX` or `PA-FE-TX` or `PA-GE` or `C2600-MB-2E` or `C7200-IO-FE` or `NM-4T` or `C2600-MB-1FE` or `C7200-IO-2FE` or `PA-POS-OC3` or `PA-4T+` or `C1700-MB-WIC1` or `NM-16ESW` or `C7200-IO-GE-E` or `NM-4E` or `GT96100-FE` or `NM-1FE-TX` or `Leopard-2FE` or `NM-1E` or `PA-4E` or ``

## dynamips_wic

No description provided for this model.

#### Type: `object(?)`

**Possible Values:** `WIC-1ENET` or `WIC-1T` or `WIC-2T` or ``

## dynamips_properties

No description provided for this model.

#### Type: `object`

> ⚠️ Additional properties are not allowed.

| Property | Type | Required | Possible values | Deprecated | Default | Description | Examples |
| -------- | ---- | -------- | --------------- | ---------- | ------- | ----------- | -------- |
| platform | `None` | ✅ | `c1700` `c2600` `c2691` `c3725` `c3745` `c3600` `c7200` |  |  |  |  |
| name | `string` |  | string |  |  |  |  |
| category | Missing type |  | [categories](#categories) |  |  |  |  |
| default_name_format | `string` |  | string |  |  |  |  |
| usage | `string` |  | string |  |  |  |  |
| symbol | `string` |  | string |  |  |  |  |
| chassis | `None` |  | `1720` `1721` `1750` `1751` `1760` `2610` `2620` `2610XM` `2620XM` `2650XM` `2621` `2611XM` `2621XM` `2651XM` `3620` `3640` `3660` `` |  |  |  |  |
| ram | `integer` |  | `1 <= x ` |  |  |  |  |
| nvram | `integer` |  | `1 <= x ` |  |  |  |  |
| idlepc | `string` |  | [`^0x[0-9a-f]{8}`](https://regex101.com/?regex=%5E0x%5B0-9a-f%5D%7B8%7D) |  |  |  |  |
| startup_config | `string` |  | string |  |  |  |  |
| wic0 | Missing type |  | [dynamips_wic](#dynamips_wic) |  |  |  |  |
| wic1 | Missing type |  | [dynamips_wic](#dynamips_wic) |  |  |  |  |
| wic2 | Missing type |  | [dynamips_wic](#dynamips_wic) |  |  |  |  |
| slot0 | Missing type |  | [dynamips_slot](#dynamips_slot) |  |  |  |  |
| slot1 | Missing type |  | [dynamips_slot](#dynamips_slot) |  |  |  |  |
| slot2 | Missing type |  | [dynamips_slot](#dynamips_slot) |  |  |  |  |
| slot3 | Missing type |  | [dynamips_slot](#dynamips_slot) |  |  |  |  |
| slot4 | Missing type |  | [dynamips_slot](#dynamips_slot) |  |  |  |  |
| slot5 | Missing type |  | [dynamips_slot](#dynamips_slot) |  |  |  |  |
| slot6 | Missing type |  | [dynamips_slot](#dynamips_slot) |  |  |  |  |
| midplane | `None` |  | `std` `vxr` |  |  |  |  |
| npe | `None` |  | `npe-100` `npe-150` `npe-175` `npe-200` `npe-225` `npe-300` `npe-400` `npe-g2` |  |  |  |  |

## qemu_disk_interfaces

No description provided for this model.

#### Type: `object(?)`

**Possible Values:** `ide` or `sata` or `nvme` or `scsi` or `sd` or `mtd` or `floppy` or `pflash` or `virtio` or `none`

## qemu_properties

No description provided for this model.

#### Type: `object`

> ⚠️ Additional properties are not allowed.

| Property | Type | Required | Possible values | Deprecated | Default | Description | Examples |
| -------- | ---- | -------- | --------------- | ---------- | ------- | ----------- | -------- |
| name | `string` |  | string |  |  |  |  |
| category | Missing type |  | [categories](#categories) |  |  |  |  |
| default_name_format | `string` |  | string |  |  |  |  |
| usage | `string` |  | string |  |  |  |  |
| symbol | `string` |  | string |  |  |  |  |
| adapter_type | `None` |  | `e1000` `i82550` `i82551` `i82557a` `i82557b` `i82557c` `i82558a` `i82558b` `i82559a` `i82559b` `i82559c` `i82559er` `i82562` `i82801` `igb` `ne2k_pci` `pcnet` `rtl8139` `virtio` `virtio-net-pci` `vmxnet3` |  |  |  |  |
| adapters | `integer` |  | integer |  |  |  |  |
| custom_adapters | `array` |  | object |  |  |  |  |
| custom_adapters[].adapter_number | `integer` | ✅ | integer |  |  |  |  |
| custom_adapters[].port_name | `string` |  | string |  |  |  |  |
| custom_adapters[].adapter_type | `string` |  | `e1000` `i82550` `i82551` `i82557a` `i82557b` `i82557c` `i82558a` `i82558b` `i82559a` `i82559b` `i82559c` `i82559er` `i82562` `i82801` `igb` `ne2k_pci` `pcnet` `rtl8139` `virtio` `virtio-net-pci` `vmxnet3` |  |  |  |  |
| custom_adapters[].mac_address | `string` |  | [`^([0-9a-fA-F]{2}[:]){5}([0-9a-fA-F]{2})$`](https://regex101.com/?regex=%5E%28%5B0-9a-fA-F%5D%7B2%7D%5B%3A%5D%29%7B5%7D%28%5B0-9a-fA-F%5D%7B2%7D%29%24) |  |  |  |  |
| first_port_name | `string` |  | string |  |  |  |  |
| port_name_format | `string` |  | string |  |  |  |  |
| port_segment_size | `integer` |  | integer |  |  |  |  |
| linked_clone | `boolean` |  | boolean |  |  |  |  |
| ram | `integer` |  | integer |  |  |  |  |
| cpus | `integer` |  | integer |  |  |  |  |
| hda_disk_interface | Missing type |  | [qemu_disk_interfaces](#qemu_disk_interfaces) |  |  |  |  |
| hdb_disk_interface | Missing type |  | [qemu_disk_interfaces](#qemu_disk_interfaces) |  |  |  |  |
| hdc_disk_interface | Missing type |  | [qemu_disk_interfaces](#qemu_disk_interfaces) |  |  |  |  |
| hdd_disk_interface | Missing type |  | [qemu_disk_interfaces](#qemu_disk_interfaces) |  |  |  |  |
| platform | `None` |  | `aarch64` `alpha` `arm` `cris` `i386` `lm32` `m68k` `microblaze` `microblazeel` `mips` `mips64` `mips64el` `mipsel` `moxie` `or32` `ppc` `ppc64` `ppcemb` `s390x` `sh4` `sh4eb` `sparc` `sparc64` `tricore` `unicore32` `x86_64` `xtensa` `xtensaeb` |  |  |  |  |
| console_type | `None` |  | `telnet` `vnc` `spice` `spice+agent` `none` |  |  |  |  |
| boot_priority | `None` |  | `d` `c` `dc` `cd` `n` `nc` `nd` `cn` `dn` |  |  |  |  |
| kernel_command_line | `string` |  | string |  |  |  |  |
| options | `string` |  | string |  |  |  |  |
| cpu_throttling | `number` |  | `0 <= x <= 100` |  |  |  |  |
| tpm | `boolean` |  | boolean |  |  |  |  |
| uefi | `boolean` |  | boolean |  |  |  |  |
| on_close | `None` |  | `power_off` `shutdown_signal` `save_vm_state` |  |  |  |  |
| process_priority | `None` |  | `realtime` `very high` `high` `normal` `low` `very low` |  |  |  |  |


---

Markdown generated with [jsonschema-markdown](https://github.com/elisiariocouto/jsonschema-markdown).
