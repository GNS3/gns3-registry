GNS3-registry
================

.. image:: https://travis-ci.org/GNS3/gns3-registry.svg
    :target: https://travis-ci.org/GNS3/gns3-registry

This is the GNS3 registry where user can share
appliances configurations and symbols.

Add a new symbol
################
Look for examples in the symbols directory.


Add a new appliance
###################

Two way to create a new appliance:
* Copy paste a JSON from the appliances directory
* Use the new_appliance.py

After that you can send us a pull request on Github.


In schemas/appliance.json you have a JSON with a schema for controlling the file
and can be use as documentation for each fields.


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

You need to install `imagemagick` before running check.py.

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
