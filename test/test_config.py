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


import pytest
import json

from gns3repository.config import Config
from gns3repository.image import Image


@pytest.fixture
def empty_config(tmpdir):
    config = {
        "LocalServer": {
            "allow_console_from_anywhere": False,
            "auto_start": False,
            "console_end_port_range": 5000,
            "console_start_port_range": 2001,
            "host": "127.0.0.1",
            "images_path": str(tmpdir),
            "path": "",
            "port": 8000,
            "projects_path": str(tmpdir),
            "report_errors": False,
            "udp_end_port_range": 20000,
            "udp_start_port_range": 10000
        },
        "Dynamips": {
            "allocate_aux_console_ports": False,
            "dynamips_path": "/Applications/GNS3.app/Contents/Resources/dynamips",
            "ghost_ios_support": True,
            "mmap_support": True,
            "routers": [
                {
                }
            ],
            "sparse_memory_support": True,
            "use_local_server": True
        },
        "IOU": {
            "devices": [
                {
                }
            ],
            "iourc_path": "/Users/noplay/code/gns3/gns3-vagrant/images/iou/iourc.txt",
            "iouyap_path": "",
            "license_check": True,
            "use_local_server": False
        },
        "Qemu": {
            "use_local_server": True,
            "vms": [
            ]
        }
    }
    path = str(tmpdir / "config")
    with open(path, "w+") as f:
        json.dump(config, f)
    return Config(path)


def test_add_image(empty_config, linux_microcore_img):
    with open("devices/microcore-linux.json") as f:
        config = json.load(f)
    image = Image(linux_microcore_img)
    image.version = "3.4.1"
    config["hda_disk_image"] = image
    empty_config.add_image(config)
    assert empty_config._config["Qemu"]["vms"][0] == {
        "adapter_type": "e1000",
        "adapters": 1,
        "category": 2,
        "cpu_throttling": 0,
        "default_symbol": ":/symbols/qemu_guest.normal.svg",
        "hda_disk_image": image.path,
        "hdb_disk_image": "",
        "hdc_disk_image": "",
        "hdd_disk_image": "",
        "hover_symbol": ":/symbols/qemu_guest.selected.svg",
        "initrd": "",
        "kernel_command_line": "",
        "kernel_image": "",
        "legacy_networking": False,
        "name": "Micro Core Linux 3.4.1",
        "options": "",
        "process_priority": "normal",
        "qemu_path": "qemu-system-i386",
        "ram": 32,
        "server": "local"
    }


def test_add_image_uniq(empty_config, linux_microcore_img):
    with open("devices/microcore-linux.json") as f:
        config = json.load(f)
    image = Image(linux_microcore_img)
    image.version = "3.4.1"
    config["hda_disk_image"] = image
    empty_config.add_image(config)
    config["adapters"] = 2
    empty_config.add_image(config)
    assert len(empty_config._config["Qemu"]["vms"]) == 1


def test_save(empty_config, linux_microcore_img):

    with open("devices/microcore-linux.json") as f:
        config = json.load(f)
    empty_config.add_image(config)
    empty_config.save()
    with open(empty_config.path) as f:
        assert "Micro Core" in f.read()
