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
import os
from unittest.mock import MagicMock, patch

from gns3registry.config import Config, ConfigException
from gns3registry.image import Image


@pytest.fixture(scope="function")
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


def test_add_images_guest(empty_config, linux_microcore_img):
    with open("devices/qemu/microcore-linux.json") as f:
        config = json.load(f)
    image = Image(linux_microcore_img)
    image.version = "3.4.1"
    config["images"]["hda_disk_image"] = image
    empty_config.add_images(config)
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
        "options": "-nographic",
        "process_priority": "normal",
        "qemu_path": "qemu-system-i386",
        "ram": 32,
        "server": "local"
    }


def test_add_images_cdrom(empty_config, linux_microcore_img):
    with open("devices/qemu/hp-vsr1001.json") as f:
        config = json.load(f)

    hda = os.path.join(empty_config.images_dir, "QEMU", "vsr1000-hp.img")

    image = Image(linux_microcore_img)
    image.version = "7.10.R0204P01"
    config["images"]["cdrom"] = image

    with patch("subprocess.call") as mock_qemu_img:
        with patch("gns3registry.config.Config._qemu_run") as mock_qemu:
            mock_qemu.return_value = hda
            empty_config.add_images(config)
    assert mock_qemu_img.called
    args, kwargs = mock_qemu_img.call_args
    assert args[0] == ["qemu-img", "create", "-f", "qcow2", hda, "8G"]

    assert mock_qemu.called
    args, kwargs = mock_qemu.call_args
    assert args[1] == "-cdrom {} -m 1024 {}".format(image.path, hda)

    assert empty_config._config["Qemu"]["vms"][0] == {
        "adapter_type": "e1000",
        "adapters": 16,
        "category": 0,
        "cpu_throttling": 0,
        "default_symbol": ":/symbols/router.normal.svg",
        "hda_disk_image": hda,
        "hdb_disk_image": "",
        "hdc_disk_image": "",
        "hdd_disk_image": "",
        "hover_symbol": ":/symbols/router.selected.svg",
        "initrd": "",
        "kernel_command_line": "",
        "kernel_image": "",
        "legacy_networking": False,
        "name": "HP VSR1001 7.10.R0204P01",
        "options": "",
        "process_priority": "normal",
        "qemu_path": "qemu-system-x86_64",
        "ram": 1024,
        "server": "local"
    }


def test_add_images_router_two_disk(empty_config):
    with open("devices/qemu/arista-veos.json") as f:
        config = json.load(f)

    image = MagicMock()
    image.version = "2.1.0"
    image.md5sum = "ea9dc1989764fc6db1d388b061340743016214a7"
    image.path = "/a"
    config["images"]["hda_disk_image"] = image

    image = MagicMock()
    image.version = "4.13.8M"
    image.md5sum = "ff50656fe817c420e9f7fbb0c0ee41f1ca52fee2"
    image.path = "/b"
    config["images"]["hdb_disk_image"] = image

    empty_config.add_images(config)
    assert empty_config._config["Qemu"]["vms"][0]["name"] == "Arista vEOS 2.1.0 4.13.8M"

    assert empty_config._config["Qemu"]["vms"][0] == {
        "adapter_type": "e1000",
        "adapters": 8,
        "category": 0,
        "cpu_throttling": 0,
        "default_symbol": ":/symbols/router.normal.svg",
        "hda_disk_image": "/a",
        "hdb_disk_image": "/b",
        "hdc_disk_image": "",
        "hdd_disk_image": "",
        "hover_symbol": ":/symbols/router.selected.svg",
        "initrd": "",
        "kernel_command_line": "",
        "kernel_image": "",
        "legacy_networking": False,
        "name": "Arista vEOS 2.1.0 4.13.8M",
        "options": "-nographic",
        "process_priority": "normal",
        "qemu_path": "qemu-system-x86_64",
        "ram": 2048,
        "server": "local"
    }


def test_add_images_uniq(empty_config, linux_microcore_img):
    with open("devices/qemu/microcore-linux.json") as f:
        config = json.load(f)

    image = Image(linux_microcore_img)
    image.version = "3.4.1"
    config["images"]["hda_disk_image"] = image

    empty_config.add_images(config)
    config["qemu"]["adapters"] = 2
    empty_config.add_images(config)
    assert len(empty_config._config["Qemu"]["vms"]) == 1
    assert empty_config._config["Qemu"]["vms"][0]["adapters"] == 2


def test_add_images_two_disk_one_missing(empty_config):
    with open("devices/qemu/arista-veos.json") as f:
        config = json.load(f)

    image = MagicMock()
    image.version = "2.1.0"
    image.md5sum = "ea9dc1989764fc6db1d388b061340743016214a7"
    config["images"]["hda_disk_image"] = image

    with pytest.raises(ConfigException):
        empty_config.add_images(config)
    assert len(empty_config._config["Qemu"]["vms"]) == 0


def test_save(empty_config, linux_microcore_img):

    with open("devices/qemu/microcore-linux.json") as f:
        config = json.load(f)

    image = Image(linux_microcore_img)
    image.version = "3.4.1"
    config["images"]["hda_disk_image"] = image

    empty_config.add_images(config)
    empty_config.save()
    with open(empty_config.path) as f:
        assert "Micro Core" in f.read()
