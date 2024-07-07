GNS3-registry
=============

[![image](https://travis-ci.org/GNS3/gns3-registry.svg)](https://travis-ci.org/GNS3/gns3-registry)

This is the GNS3 registry where user can share appliances and symbols.

Policy for new appliances
-------------------------

We welcome pull requests for new appliances.

Regarding images / disks referenced in new appliance files, we accept
links that point to well-known vendor websites or other trusted source
websites.

For new contribution, we accept links depending on multiple criteria:
the kind of appliance, who submits it and especially if scripts to build
the images(s) are provided (packer scripts are recommended for Qemu
appliances). Then we will build on our side, verify and upload the
image(s) on the GNS3 Sourceforge account.

For Docker appliances, please provide a Dockerfile.
We will then build and push the image on Docker hub.

Adding a new appliance
-------------------

There are two ways to create a new appliance:

* Copy and paste a JSON from the `appliances` directory
* Run `new_appliance.py`

After that you can send us a pull request on Github

In schemas/appliance.json you have a JSON with a schema for controlling
the file and can be use as documentation for each field.

### Versioning

GNS3 checks the schema version, if the schema of an appliance is not supported it shows the error "Please update GNS3 in order to install this appliance".

| Schema | min. GNS3 version | Additions                                                                                |
| :-: |:-----------------:|------------------------------------------------------------------------------------------|
| 2 |       1.4.0       |                                                                                          |
| 3 |       1.5.0       | docker                                                                                   |
| 4 |       2.0.0       | availability<br>qemu/cpus<br>qemu/hd?_disk_interface: sata<br>versions/images/bios_image |
| 5 |       2.1.0       | qemu/console_type: spice                                                                 |
| 6 |       2.2.0       | qemu/custom_adapters<br>qemu/console_type: spice+agent<br>all/console_type: none         |
| 7 |      2.2.36       | qemu/tpm                                                                                 |
| 8 |      2.2.43       | See below                                                                                |

### Schema version 8

Schema version 8 has introduced many changes in the appliance schema. The most important are:

* Support for `uefi_boot_mode` property in Qemu template properties.
* Possibility to have multiple set of settings to use with different image versions. Default settings are specified if 

1. a `default` field set to `true` exists
2. there is only one set present.

**Notes**

A `template_type` field must be added to tell GNS3 what template to create (qemu, iou, dynamips or docker), mixing different template types is not supported at the moment.
All template specific properties are defined in a `template_properties` field.

**Example**

```json
"settings": [
    {
        "default": true,
        "template_type": "qemu",
        "template_properties": {
            "platform": "x86_64",
            "adapter_type": "e1000",
            "adapters": 1,
            "ram": 1024,
            "console_type": "vnc"
        }
    },
    {
        "name": "i386 settings",
        "template_type": "qemu",
        "template_properties": {
            "platform": "i386",
            "adapters": 8
        }
    },
    {
        "name": "ARM settings",
        "template_type": "qemu",
        "template_properties": {
            "platform": "arm",
            "ram": 512
        }
    }
],
"versions": [
    {
        "name": "1.0",
        "images": {
            "hda_disk_image": "disk1.qcow2"
        }
    },
    {
        "name": "2.0",
        "settings": "i386 settings",
        "images": {
            "hda_disk_image": "disk2.qcow2"
        }
    },
    {
        "name": "3.0",
        "settings": "ARM settings",
        "images": {
            "hda_disk_image": "disk3.qcow2"
        }
    },
]
```

* The default settings are inherited by other settings set, this can be blocked by setting `inherit_default_properties` to `false`
* The controller template default is used if a template property is not defined or inherited from the default settings.
* The `md5sum` field is renamed `checksum`. The `md5sum` field is still accepted for easier migration from previous format versions.
* New optional `checksum_type` field for future development. The default and only checksum type remains MD5 for now.
* New optional `default_username` and `default_password` fields at the appliance and version levels.
* New optional `installation_instructions` field at the appliance and version levels to give download/unpack instructions to some appliances.
* New optional `compression_target` field to be used along with the compression field in future development.
* The `idlepc` field in versions section is moved to the `template_properties` for the `dynamips` template type
* The `first_port_name`, `port_name_format`, `port_segment_size` and `linked_clone` fields are moved to the `template_properties` for the qemu template type (these fields are only valid for Qemu templates).
* The `arch` field for qemu has been renamed `platform` to match the template properties on the controller side.
* The `kvm` field has been dropped and no longer required. Installing an appliance shouldn't take into account the available servers and their capabilities (e.g. capable of running kvm etc.)
* The `category`, `usage` and `symbol` fields can be defined in any `template_properties`. Defaults are at the appliance level or version level (they will be injected in `template_properties` if there aren't already defined there).
* The appliance version installed will be injected in the `version` field of the template (only controller version >= v3.0)
* Add `name` and `default_name_format` fields to all template properties.
* Add `console_resolution`, `extra_hosts` and `extra_volumes` to Docker template properties.
* Allow `spice+agent` in `console_type` for Qemu template properties.

**Full example**

```json
{
    "appliance_id": "709c2a9b-5dc3-4362-b147-fb848a0df963",
    "name": "My appliance",
    "category": "router",
    "description": "This is my new appliance",
    "vendor_name": "Cisco",
    "vendor_url": "http://www.cisco.com/",
    "documentation_url": "https://www.cisco.com/c/en/us/support/routing/xxx",
    "product_name": "Appliance product xxx",
    "product_url": "https://www.cisco.com/c/en/us/products/xxx/index.html",
    "registry_version":8,
    "status": "experimental",
    "maintainer": "GNS3 Team",
    "maintainer_email": "developers@gns3.net",
    "installation_instructions": "This is how to install this appliance",
    "usage": "This is how to use my appliance",
    "symbol": "router.svg",
    "default_username": "cisco",
    "default_password": "admin",
    "settings": [
        {
            "name": "Default template settings",
            "default": true,
            "template_type": "qemu",
            "template_properties":
                {
                    "symbol": "multilayer_router.svg",
                    "first_port_name": "ethernet0",
                    "port_name_format": "ethernet{port1}",
                    "adapter_type": "e1000",
                    "adapters": 2,
                    "ram": 4096,
                    "cpus": 1,
                    "hda_disk_interface": "scsi",
                    "platform": "x86_64",
                    "console_type": "vnc",
                    "boot_priority": "cd",
                    "options": ""
                }
        },
        {
            "name": "Custom settings for version 7.10.2",
            "template_type": "qemu",
            "inherit_default_properties": false,
            "template_properties":
                {
                    "adapters": 4,
                    "ram": 8192,
                    "cpus": 1
                }
        }
    ],
    "images": [
        {
            "filename": "file.iso",
            "version": "7.10.2",
            "checksum": "ef8712e655fcbc92dc1a1551ee2e4a80",
            "checksum_type": "md5",
            "filesize": 1287245824,
            "download_url": "https://software.cisco.com/download/home/286307342/type/286307754/release/7.10.2"
        },
        {
            "filename": "file2.iso",
            "version": "6.10.4",
            "checksum": "68232f77da8f78cdc9aa6f3266a4d4c0",
            "filesize": 3949459594,
            "download_url": "https://software.cisco.com/download/home/286307342/type/286307754/release/6.10.4"
        },
        {
            "filename": "empty100G.qcow2",
            "version": "1.0",
            "md5sum": "1e6409a4523ada212dea2ebc50e50a65",
            "filesize": 198656,
            "download_url": "https://sourceforge.net/projects/gns-3/files/Empty%20Qemu%20disk/",
            "direct_download_url": "https://sourceforge.net/projects/gns-3/files/Empty%20Qemu%20disk/empty100G.qcow2/download"
        }
    ],
    "versions": [
        {
            "name": "7.10.2",
            "settings": "Custom settings for version 7.10.2",
            "images": {
                "hda_disk_image": "empty100G.qcow2",
                "cdrom_image": "file.iso"
            }
        },
        {
            "name": "6.10.4",
            "default_username": "admin123",
            "default_password": "admin123",
            "installation_instructions": "This is how to install this version",
            "usage": "This is how to use this version",
            "symbol": "ethernet_switch.svg",
            "images": {
                "hda_disk_image": "empty100G.qcow2",
                "cdrom_image": "file2.iso"
            }
        }
    ]
}
```

Adding a new symbol
-------------------

Look for examples in the `symbols` directory.

Docker container
----------------

This repository also contains the source of Docker container published by
the GNS3 team and that can be used as an appliance in GNS3.

Tools
-----

All tools require python3 and dependencies can be installed using pip:

``` {.bash}
python3 -m pip install -r requirements.txt
```

### Check appliance files

``` {.bash}
python3 check.py
python3 check_urls.py
```

### Create a new appliance

``` {.bash}
python3 new_appliance.py
```

### Prettify appliances JSON

This will indent the JSON of all appliance and sort the key in same
order as the JSON schema.

``` {.bash}
python3 prettify_appliances.py
```
