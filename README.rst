GNS3-registry
================


This is the GNS3 registry.

    


Add a new appliance
###################

Copy paste a JSON from the appliances directory and send a pull request.


In schemas/appliance.json you have a JSON with a schema for controlling the file.


Tools
#######

All tools require python3 and the installation of dependencies via:

.. code:: bash 

    pip3 install -r requirements.txt


Build website
--------------

.. code:: bash
    
    python3 build.py


Run website
-------------

.. code:: bash
    
    python3 server.py


Check appliance files
-----------------------

.. code:: bash
    
    python3 check.py

