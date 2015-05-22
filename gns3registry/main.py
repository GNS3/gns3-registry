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

import argparse
import sys
import os
from distutils.util import strtobool

sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), "..")))

from gns3registry.registry import Registry
from gns3registry.config import Config, ConfigException

registry = Registry()
config = Config()


def yes_no(message):
    while True:
        try:
            return strtobool(input("{} (y/n) ".format(message)).lower())
        except ValueError:
            pass

def add_images(images):
    print("WARNING WARNING WARNING")
    print("It's experimental")
    print("Please close the GUI before using it")
    print("")

    confs = registry.detect_images(images)
    if len(confs) > 0:
        print("Found: {} devices configuration".format(len(confs)))
        for conf in confs:
            if yes_no("Add {}?".format(conf["name"])):
                try:
                    config.add_images(conf)
                except ConfigException as e:
                    print(e, file=sys.stderr)
                    sys.exit(1)
        config.save()


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Manage GNS3 registry")
    parser.add_argument("--add", dest="add_images", action="store", nargs='+',
                       help="Add images to GNS3")
    parser.add_argument("--search", dest="search", action="store",
                       help="Search an image for GNS3")
    parser.add_argument("--install", dest="install", action="store",
                       help="Download and install an image for GNS3")
    parser.add_argument("--test", dest="test", action="store_true",
                       help="Test if installation of gns3 registry is OK")

    args = parser.parse_args()

    if args.test:
        sys.exit(0)

    if args.add_images:
        add_images(args.add_images)
    elif args.search:
        print("Available images\n")
        for res in registry.search_device(args.search):
            print("{}: ".format(res["name"]))
            for image_type in res["images"]:
                print(" * {}:".format(image_type))
                for file in res["images"][image_type]:
                    print("   * {} {}: {}".format(file["version"], file["filename"], file["sha1sum"]))
    elif args.install:
        image = registry.download_image(args.install, config.images_dir)
        if image:
            add_images([image])
    else:
        parser.print_help()
        sys.exit(1)

