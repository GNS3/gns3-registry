Packer for Alpine GNS3 appliance
================================

For building an Alpine appliance.

https://alpinelinux.org/


Alpine CLI installation
***********************

The only added packages are:

* busybox-extras
* nano

.. code:: bash

    packer build alpine.json


FRR
''''

A build of Alpine with FRRouting preinstalled.

.. code:: bash

    packer build -var-file=frr.json alpine.json


Alpine GUI installation
***********************

The GUI version has XFCE4 installed.

.. code:: bash

    packer build -var-file=gui.json alpine.json


AArch64 builds
**************

The AArch64 variants use QEMU's ``virt`` machine and the Alpine ``aarch64``
virt ISO. QEMU must provide ``qemu-system-aarch64`` and an AArch64 UEFI
firmware code/variables pair. The defaults are
``/usr/share/AAVMF/AAVMF_CODE.fd`` and ``/usr/share/AAVMF/AAVMF_VARS.fd``;
override ``efi_firmware_code`` and ``efi_firmware_vars`` if needed.

Installation runs through the VM's serial console, exposed as a QEMU virtual
console for Packer keyboard input and logged to ``serial.out``. Packer serves
the installation scripts over HTTP; no SSH communicator or provisioners are
used. The installed system is configured in a chroot before powering off,
without an intermediate reboot. CLI and FRR images use ``ttyAMA0`` for serial
autologin. Failed installation commands leave the VM running for inspection
until the shutdown timeout expires.

Run these commands from this directory:

.. code:: bash

    packer build alpine-aarch64.json
    packer build -var-file=frr-aarch64.json alpine-aarch64.json
    packer build -var-file=gui-aarch64.json alpine-aarch64.json

The AArch64 GUI image automatically logs in as ``user`` and starts XFCE.
