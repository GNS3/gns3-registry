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


"""
Create a new appliance from the terminal
"""

import json
import os
import sys


def ask_multiple(question, options, optional=False):
    while True:
        for i, option in enumerate(options):
            question += '\n{}) {}'.format(i + 1, option)
        question += '\n'
        answer = ask(question, type='integer', optional=optional)
        if answer is None:
            if optional:
                return None
        else:
            if answer > 0 and answer <= len(options):
                return options[answer - 1]


def yesno(question):
    while True:
        answer = ask(question + '[y/n]')
        if answer in ['y', 'Y', 'yes']:
            return True
        if answer in ['n', 'N', 'no']:
            return False


def ask(question, type='string', optional=False):
    while True:
        if optional:
            sys.stdout.write(question + "(optional leave blank for skip) : ")
        else:
            sys.stdout.write(question + ": ")
        sys.stdout.flush()
        val = sys.stdin.readline().strip()
        if len(val) == 0:
            if optional:
                return None
            continue
        if type == 'integer':
            try:
                val = int(val)
            except ValueError:
                continue
        sys.stdout.write("\n")
        return val


def ask_from_schema(schema):
    data = {}
    for key,val in schema['properties'].items():
        optional = not key in schema['required']
        result = None

        if 'enum' in val:
            result = ask_multiple(val['title'], val['enum'], optional=optional)
        elif val['type'] in ('integer', 'string'):
            result = ask(val['title'], type=val['type'], optional=optional)

        if result:
            data[key] = result
    return data


with open(os.path.join('schemas', 'appliance_v5.json')) as f:
    schema = json.load(f)


appliance_name = ask('Appliance id (example: cisco-asav)')

# TODO check if file exists
with open(os.path.join('appliances', appliance_name + '.gns3a'), 'w+') as f:
    appliance = {}
    appliance = ask_from_schema(schema)
    appliance['qemu'] = ask_from_schema(schema['properties']['qemu'])

    appliance['images'] = []
    files = []
    while yesno('Add image?'):
        image = ask_from_schema(schema['properties']['images']['items'])
        appliance['images'].append(image)
        files.append(image['filename'])

    appliance['versions'] = []
    while yesno('Add appliance version?'):
        version = {'images': {}}
        version['name'] = ask('Appliance version name')
        for disk in ['hda_disk_image', 'hdb_disk_image', 'hdc_disk_image', 'hdd_disk_image', 'cdrom_image', 'initrd_image', 'kernel_image']:
            img = ask_multiple('Image for ' + disk, files, optional=True)
            if img:
                version['images'][disk] = img

        appliance['versions'].append(version)

    json.dump(appliance, f, indent=4)
