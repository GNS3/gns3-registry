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
This file is sample tools for patching all appliances. It's useful when
you need to add a property to all appliances.
"""

import glob
import sys
import json
import jsonschema

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


with open('schemas/appliance_v7.json') as f:
    schema = json.load(f)

for appliance in glob.glob('appliances/*.gns3a'):
    print('=> Patch', appliance)
    # Load appliance
    with open(appliance) as f:
        config = json.load(f)

    # Our patch
    if not 'qemu' in config:
        continue
    config['qemu']['kvm'] = ask_multiple('KVM support for {}'.format(appliance), ['require', 'allow', 'disable'])

    # Validate our changes
    jsonschema.validate(config, schema)

    # Save
    with open(appliance, 'w') as f:
        json.dump(config, f, indent=4)
