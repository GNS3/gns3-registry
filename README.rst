GNS3-registry
================

.. image:: https://travis-ci.org/GNS3/gns3-registry.svg
    :target: https://travis-ci.org/GNS3/gns3-registry

This is the GNS3 registry where user can share
appliances configurations and symbols.

Policy for new appliances
#########################

We welcome pull requests for new appliances.

Regarding images / disks referenced in new appliance files, we accept links
that point to well-known vendor websites or other trusted source websites.

For new contribution, we accept links depending on multiple criteria: the kind of appliance,
who submits it and especially if scripts to build the images(s) are provided (packer scripts are
recommended for Qemu appliances). Then we will build on our side, verify and upload the image(s)
on the GNS3 Sourceforge account.

For Docker appliances, please provide a Dockerfile.

Add a new symbol
################
Look for examples in the symbols directory.


Add a new appliance
###################

Two way to create a new appliance:
 - Copy paste a JSON from the appliances directory
 - Use the new_appliance.py

After that you can send us a pull request on Github.


In schemas/appliance.json you have a JSON with a schema for controlling the file
and can be use as documentation for each fields.

Docker container
################

This repository contain also the source of Docker container publish by the GNS3
team and that can be used as appliance in GNS3.

Tools
#######

All tools require python3 and the installation of dependencies via:

.. code:: bash

    pip3 install -r requirements.txt


Check appliance files
-----------------------

.. code:: bash

    python3 check.py
    python3 check_urls.py

If `imagemagick` is installed, it will be used to check the symbol properties.
Otherwise an (experimental) internal function will do that.

Create a new appliance
-----------------------

.. code:: bash

    python3 new_appliance.py


Prettify appliances JSON
-------------------------

This will indent the JSON of all appliance and sort the key in same order as
the JSON schema.

.. code:: bash
    python3 prettify_appliances.py
