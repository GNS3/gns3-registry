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
from gns3repository.image import Image


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

    def add_image(self, device_config):
        """
        Add an image to the user configuration
        """
        new_config = {
            "server": "local",
            "name": device_config["name"]
        }
        if device_config["category"] == "guest":
            new_config["category"] = 2
        if device_config["emulator"] == "qemu":
            self._add_qemu_config(new_config, device_config)

    def _add_qemu_config(self, new_config, device_config):

        new_config["adapter_type"] = device_config["adapter_type"]
        new_config["adapters"] = device_config["adapters"]
        new_config["cpu_throttling"] = 0
        new_config["ram"] = device_config["ram"]
        new_config["legacy_networking"] = False
        new_config["process_priority"] = "normal"

        new_config["initrd"] = ""
        new_config["kernel_command_line"] = ""
        new_config["kernel_image"] = ""
        new_config["options"] = ""
        new_config["hdb_disk_image"] = ""
        new_config["hdc_disk_image"] = ""
        new_config["hdd_disk_image"] = ""

        #TODO: Manage Windows
        if device_config["processor"] == "i386":
            new_config["qemu_path"] = "qemu-system-i386"

        if device_config["category"] == "guest":
            new_config["default_symbol"] = ":/symbols/qemu_guest.normal.svg"
            new_config["hover_symbol"] = ":/symbols/qemu_guest.selected.svg"

        if isinstance(device_config["hda_disk_image"], Image):
            new_config["name"] += " {}".format(device_config["hda_disk_image"].version)
            new_config["hda_disk_image"] = device_config["hda_disk_image"].path

        # Remove VM with the same Name
        self._config["Qemu"]["vms"] = [item for item in self._config["Qemu"]["vms"] if item["name"] != new_config["name"]]

        self._config["Qemu"]["vms"] .append(new_config)

    def save(self):
        """
        Save the configuration file
        """
        with open(self.path, "w+") as f:
            json.dump(self._config, f)

