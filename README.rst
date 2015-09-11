GNS3-registry
================


This is the GNS3 registry where user can share
appliances configurations.


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


Create a new appliance
-----------------------

.. code:: bash

    python3 new_appliance.py

