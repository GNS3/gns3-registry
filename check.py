#!/usr/bin/env python
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

import os
import jsonschema
import json
import sys
import subprocess


def check_appliance(appliance):
    global images
    images = set()
    global md5sums
    md5sums = set()

    with open('schemas/appliance_v4.json') as f:
        schema_v4 = json.load(f)
    with open('schemas/appliance_v3.json') as f:
        schema_v3 = json.load(f)

    with open(os.path.join('appliances', appliance)) as f:
        appliance_json = json.load(f)
        if appliance_json['registry_version'] == 3:
            jsonschema.validate(appliance_json, schema_v3)
        elif appliance_json['registry_version'] == 4:
            jsonschema.validate(appliance_json, schema_v4)
            try:
                appliance_json_v3 = appliance_json.copy()
                appliance_json_v3['registry_version'] = 3
                jsonschema.validate(appliance_json_v3, schema_v3)
                print('Appliance ' + appliance + ' can be downgraded to registry version 3')
                sys.exit(1)
            except jsonschema.exceptions.ValidationError:
                # The appliance require the schema V4
                pass
        else:
            return
            print('Schema version {} is not supported'.format(appliance_json['registry_version']))
            sys.exit(1)

    if 'images' in appliance_json:
        for image in appliance_json['images']:
            if image['filename'] in images:
                print('Duplicate image filename ' + image['filename'])
                sys.exit(1)
            if image['md5sum'] in md5sums:
                print('Duplicate image md5sum ' + image['md5sum'])
                sys.exit(1)
            images.add(image['filename'])
            md5sums.add(image['md5sum'])

        for version in appliance_json['versions']:
            for image in version['images'].values():
                found = False
                for i in appliance_json['images']:
                    if i['filename'] in image:
                        found = True

                if not found:
                    print('Missing relation ' + image + ' in ' + appliance + ' for version ' + version['name'])
                    sys.exit(1)


def check_packer(packer):
    path = os.path.join('packer', packer)
    if not os.path.isdir(path):
        return
    for file in os.listdir(path):
        if file.endswith('.json'):
            print('Check {}/{}'.format(packer, file))
            with open(os.path.join('packer', packer, file)) as f:
                json.load(f)


def check_symbol(symbol):
    licence_file = os.path.join('symbols', symbol.replace('.svg', '.txt'))
    if not os.path.exists(licence_file):
        print("Missing licence {} for {}".format(licence_file, symbol))
        sys.exit(1)
    height = int(subprocess.check_output(['identify', '-format', '%h', os.path.join('symbols', symbol)], shell=False))
    if height > 70:
        print("Symbol height of {} is too big {} > 70".format(symbol, height))
        sys.exit(1)


def main():
    print("=> Check appliances")
    for appliance in os.listdir('appliances'):
        print('Check {}'.format(appliance))
        check_appliance(appliance)
    print("=> Check symbols")
    for symbol in os.listdir('symbols'):
        if symbol.endswith('.svg'):
            print('Check {}'.format(symbol))
            check_symbol(symbol)
    print("=> Check packer files")
    for packer in os.listdir('packer'):
        check_packer(packer)
    print("Everything is ok!")

if __name__ == '__main__':
    main()
