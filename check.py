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

def check_schema(appliance):
    with open('schemas/appliance.json') as f:
        schema = json.load(f)

    with open(os.path.join('appliances', appliance)) as f:
        appliance_json = json.load(f)
        jsonschema.validate(appliance_json, schema)


def check_symbol(symbol):
    licence_file = os.path.join('symbols', symbol.replace('.svg', '.txt'))
    if not os.path.exists(licence_file):
        print("Missing licence {} for {}".format(licence_file, symbol))
        sys.exit(1)


def main():
    print("=> Check appliances")
    for appliance in os.listdir('appliances'):
        print('Check {}'.format(appliance))
        check_schema(appliance)
    print("=> Check symbols")
    for symbol in os.listdir('symbols'):
        if symbol.endswith('.svg'):
            print('Check {}'.format(symbol))
            check_symbol(symbol)

if __name__ == '__main__':
    main()
