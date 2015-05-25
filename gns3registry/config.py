#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
# Copyright (C) 2015 GNS3 Technologies Inc.
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.


import json
import sys
import os
import shlex
import subprocess
from gns3registry.image import Image


class ConfigException(Exception):
    pass


class Config:
    """
    GNS3 config file
    """

    def __init__(self, path=None):
        """
        :params path: Path of the configuration file otherwise detect it on the system
        """

        #TODO: Manage errors
        self.path = path
        if self.path is None:
            self.path = self._get_standard_config_file_path()

        with open(self.path) as f:
            self._config = json.load(f)

    @property
    def images_dir(self):
        """
        :returns: Localion of the images directory on the server
        """
        return self._config["LocalServer"]["images_path"]

    def _get_standard_config_file_path(self):
        if sys.platform.startswith("win"):
            filename = "gns3_gui.ini"
        else:
            filename = "gns3_gui.conf"

        if sys.platform.startswith("darwin"):
            appname = "gns3.net"
        else:
            appname = "GNS3"

        if sys.platform.startswith("win"):
            appdata = os.path.expandvars("%APPDATA%")
            return os.path.join(appdata, appname, filename)
        else:
            home = os.path.expanduser("~")
            return os.path.join(home, ".config", appname, filename)

    def add_images(self, device_config):
        """
        Add images to the user configuration
        """
        new_config = {
            "server": "local",
            "name": device_config["name"]
        }
        if device_config["category"] == "guest":
            new_config["category"] = 2
        elif device_config["category"] == "router":
            new_config["category"] = 0

        if "qemu" in device_config:
            self._add_qemu_config(new_config, device_config)

    def _add_qemu_config(self, new_config, device_config):

        new_config["adapter_type"] = device_config["qemu"]["adapter_type"]
        new_config["adapters"] = device_config["qemu"]["adapters"]
        new_config["cpu_throttling"] = 0
        new_config["ram"] = device_config["qemu"]["ram"]
        new_config["legacy_networking"] = False
        new_config["process_priority"] = "normal"

        new_config["initrd"] = ""
        new_config["kernel_command_line"] = ""
        new_config["kernel_image"] = ""

        if device_config["qemu"].get("graphic", False):
            options = ""
        else:
            options = "-nographic "
        options += device_config["qemu"].get("options", "")

        new_config["options"] = options.strip()

        new_config["hda_disk_image"] = device_config["qemu"].get("hda_disk_image", "")
        new_config["hdb_disk_image"] = device_config["qemu"].get("hdb_disk_image", "")
        new_config["hdc_disk_image"] = device_config["qemu"].get("hdc_disk_image", "")
        new_config["hdd_disk_image"] = device_config["qemu"].get("hdd_disk_image", "")

        new_config["qemu_path"] = self._get_qemu_binary(device_config)

        if device_config["category"] == "guest":
            new_config["default_symbol"] = ":/symbols/qemu_guest.normal.svg"
            new_config["hover_symbol"] = ":/symbols/qemu_guest.selected.svg"
        elif device_config["category"] == "router":
            new_config["default_symbol"] = ":/symbols/router.normal.svg"
            new_config["hover_symbol"] = ":/symbols/router.selected.svg"

        disks = ["hda_disk_image", "hdb_disk_image", "hdc_disk_image", "hdd_disk_image", "cdrom"]
        for disk in disks:
            if disk in device_config["images"]:
                if isinstance(device_config["images"][disk], list):
                    require_images = ""
                    for image in device_config["images"][disk]:
                        require_images += "* {}\n".format(image["filename"])
                        raise ConfigException("Missing image for {} you should provide one of the following images:\n{}".format(disk, require_images))
                else:
                    new_config["name"] += " {}".format(device_config["images"][disk].version)
                    new_config[disk] = device_config["images"][disk].path


        if device_config["qemu"].get("install_cdrom_to_hda", False):
            new_config["hda_disk_image"] = self._create_qemu_img(device_config, new_config)
            if "cdrom" in new_config:
                self._install_qemu_cdrom(device_config, new_config)
                del new_config["cdrom"]

        # Remove VM with the same Name
        self._config["Qemu"]["vms"] = [item for item in self._config["Qemu"]["vms"] if item["name"] != new_config["name"]]

        self._config["Qemu"]["vms"].append(new_config)

    def _get_qemu_binary(self, device_config):
        """
        Create a blank hda disk image

        :param device_config: The require device configuration
        """
        #TODO: Manage Windows
        if device_config["qemu"]["processor"] == "i386":
            return "qemu-system-i386"
        elif device_config["qemu"]["processor"] == "x64":
            return "qemu-system-x86_64"

    def _create_qemu_img(self, device_config, new_config):
        """
        Create a blank hda disk image

        :param device_config: The require device configuration
        :param new_config: The GNS3 device configuration
        :returns: Return new disk path
        """
        #TODO: Manage error
        image_path = os.path.join(self.images_dir, "QEMU", device_config["qemu"]["hda_disk_image"])
        #TODO: raise an error if size is missing
        cmd = ["qemu-img", "create", "-f", "qcow2", image_path, device_config["qemu"]["hda_disk_size"]]
        print(" ".join(cmd))
        subprocess.call(cmd)
        return image_path

    def _install_qemu_cdrom(self, device_config, new_config):
        """
        Install the cdrom to disk

        :param device_config: The require device configuration
        :param new_config: The GNS3 device configuration
        """

        print("Starting cdrom installation. Please follow the instructions in the qemu Windows and close qemu when install is finish in order to finish the process.")
        print("\nInstall instructions:")
        print(device_config["qemu"]["install_instructions"])
        cmd = "{options} -cdrom {cdrom} -m {ram} {hda}".format(
            options=device_config.get("options", ""),
            cdrom=device_config["images"]["cdrom"].path,
            ram=device_config["qemu"]["ram"],
            hda=new_config["hda_disk_image"])
        self._qemu_run(device_config, cmd.strip())

    def _qemu_run(self, device_config, cmd):
        """
        Run the qemu command
        """
        cmd = shlex.split(cmd)
        cmd.insert(0, self._get_qemu_binary(device_config))
        print(" ".join(cmd))
        subprocess.call(cmd)

    def save(self):
        """
        Save the configuration file
        """
        with open(self.path, "w+") as f:
            json.dump(self._config, f, indent=4)

