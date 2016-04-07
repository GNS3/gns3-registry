#!/usr/bin/env python
#
# Copyright (C) 2016 GNS3 Technologies Inc.
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

import configparser

bays = 16
units = 4
ethernet_adapters = 0

with open("/proc/net/dev") as f:
    for line in f.readlines():
        if "eth" in line:
            ethernet_adapters += 1


with open("NETMAP", "w", encoding="utf-8") as f:
    ethernet_id = 0
    for bay in range(0, bays):
        for unit in range(0, units):
            if ethernet_id >= ethernet_adapters:
                break
            f.write("{iouyap_id}:{bay}/{unit}{iou_id:>5d}:{bay}/{unit}\n".format(iouyap_id=str(1 + 512),
                                                                                 bay=bay,
                                                                                 unit=unit,
                                                                                 iou_id=1))
            ethernet_id += 1



iouyap_ini = "iouyap.ini"

config = configparser.ConfigParser()
config["default"] = {"netmap": "NETMAP",
                     "base_port": "49000"}

ethernet_id = 0
for bay_id in range(0, bays):
    for unit_id in range(0, units):
        if ethernet_id >= ethernet_adapters:
            break
        connection = {"eth_dev": "eth{ethernet_id}".format(ethernet_id=ethernet_id)}
        ethernet_id += 1

        interface = "{iouyap_id}:{bay}/{unit}".format(iouyap_id=str(1 + 512), bay=bay_id, unit=unit_id)
        config[interface] = connection
        unit_id += 1
    bay_id += 1

with open(iouyap_ini, "w", encoding="utf-8") as config_file:
    config.write(config_file)
