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

| Schema | min. GNS3 version | Additions |
| :-: | :-----: | --------- |
| 2 | 1.4.0 | |
| 3 | 1.5.0 | docker |
| 4 | 2.0.0 | availability<br>qemu/cpus<br>qemu/hd?_disk_interface: sata<br>versions/images/bios_image |
| 5 | 2.1.0 | qemu/console_type: spice |
| 6 | 2.2.0 | qemu/custom_adapters<br>qemu/console_type: spice+agent<br>all/console_type: none|
| 7 | 2.2.36 | qemu/tpm |

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
