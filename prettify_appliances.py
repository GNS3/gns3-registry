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
Prettify all appliances JSON
"""

import glob
import json
import jsonschema
import urllib
from collections import OrderedDict

def clean_urls(obj):
    """
    All url key are properly escaped
    """
    for key in obj.keys():
        if key.endswith("_url"):
            if not "%" in obj[key]:
                obj[key] = obj[key].replace(' ', '%20')


def sort_key_using_schema(schema, key):
    """
    Sort by position of a key in the JSON
    """

    return list(schema['properties'].keys()).index(key)

with open('schemas/appliance.json') as f:
    schema = json.load(f, object_pairs_hook=OrderedDict)

for appliance in glob.glob('appliances/*.gns3a'):
    print('=> Prettify', appliance)
    # Load appliance
    with open(appliance) as f:
        config = json.load(f)

    config = OrderedDict(sorted(config.items(), key=lambda t: sort_key_using_schema(schema, t[0])))
    clean_urls(config)

    for key,val in config.items():
        if isinstance(val, dict):
            config[key] = OrderedDict(sorted(val.items(), key=lambda t: sort_key_using_schema(schema['properties'][key], t[0])))

    if 'images' in config:
        images = []
        for image in config['images']:
            clean_urls(image)
            images.append(OrderedDict(sorted(image.items(), key=lambda t: sort_key_using_schema(schema['properties']['images']['items'], t[0]))))
        images = sorted(images, key=lambda t: t['version'], reverse=True)
        config['images'] = images

    if 'versions' in config:
        versions = []
        for version in config['versions']:
            version = OrderedDict(sorted(version.items(), key=lambda t: sort_key_using_schema(schema['properties']['versions']['items'], t[0])))
            version['images'] = OrderedDict(sorted(version['images'].items(), key=lambda t: sort_key_using_schema(schema['properties']['versions']['items']['properties']['images'], t[0])))
            versions.append(version)
        versions = sorted(versions, key=lambda t: t['name'], reverse=True)
        config['versions'] = versions

    # Validate our changes
    jsonschema.validate(config, schema)

    # Save
    with open(appliance, 'w') as f:
        json.dump(config, f,indent=4)
        f.write("\n")

