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

from gns3repository.repository import Repository


def test_detect_image(linux_microcore_img):

    with open("devices/microcore-linux.json") as f:
        config = json.load(f)

    repository = Repository()
    detected = repository.detect_image(linux_microcore_img)
    assert detected[0]["name"] == "Micro Core Linux"
    assert detected[0]["hda_disk_image"].version == "3.4.1"


def test_detect_unknow_image(empty_file):
    repository = Repository()
    assert repository.detect_image(empty_file) == []
