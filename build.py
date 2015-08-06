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
import sys
import json
import shutil
import copy
import base64

from jinja2 import Environment, FileSystemLoader

import logging
log = logging.getLogger(__name__)
log.setLevel(logging.DEBUG)

handler = logging.StreamHandler(sys.stdout)
formatter = logging.Formatter('%(asctime)s %(levelname)s %(message)s')
handler.setFormatter(formatter)
log.addHandler(handler)

if os.path.exists('build'):
    for file in os.listdir('build'):
        if os.path.isdir(os.path.join('build', file)):
            shutil.rmtree(os.path.join('build', file))
        else:
            os.remove(os.path.join('build', file))
else:
    os.mkdir('build')
os.mkdir(os.path.join('build', 'appliances'))
os.mkdir(os.path.join('build', 'images'))


def render(template_file, out, **kwargs):
    log.info('Build %s', out)
    env = Environment(loader=FileSystemLoader('templates'))
    env.filters['nl2br'] = lambda s: s.replace('\n', '<br />')
    env.filters['jsonify'] = json.dumps
    env.filters['b64encode'] = lambda s: base64.b64encode(s.encode()).decode("utf-8")
    template = env.get_template(template_file)
    template.stream(**kwargs).dump(os.path.join('build', out))


def keep_only_version_with_appliance(md5sum, appliance):
    """
    Filter appliance version in order to keep only the
    version where the image is present.

    :param md5sum: Md5sum of the image
    :param appliance: Device hash
    :returns: List of version
    """

    new_versions = []
    for version in appliance["versions"]:
        found = False
        for image in version["images"].values():
            if image["md5sum"] == md5sum:
                found = True
                break
        if found:
            new_versions.append(version)
    return new_versions


render('index.html', 'index.html')
render('chat.html', 'chat.html')
render('downloads.html', 'downloads.html')


appliances = []
for appliance_file in os.listdir('appliances'):
    log.info("Process " + appliance_file)
    out_filename = appliance_file[:-5]
    with open(os.path.join('appliances', appliance_file)) as f:
        appliance = json.load(f)
    appliance['id'] = out_filename

    # Resolve version image to the corresponding file
    for version in appliance['versions']:
        for image_type, filename in version['images'].items():
            found = False
            for file in appliance['images']:
                if file['filename'] == filename:
                    version['images'][image_type] = copy.copy(file)
                    version['images'][image_type]["type"] = image_type
                    found = True
                    break
            if not found:
                log.critical('Image for {} {} with filename {} is missing'.format(appliance["name"], version["name"], file['filename']))
                sys.exit(1)


    render('appliance.html', os.path.join('appliances', out_filename + '.html'), appliance=appliance)
    appliances.append(appliance)

    # Build a page named with the md5sum of each file of the appliance
    # it's allow to get the appliance informations via HTTP with just an md5sum
    # it's what powered the import feature
    for image in appliance['images']:
        # We keep only version with this image in the page
        image_appliance = copy.copy(appliance)
        image_appliance['versions'] = keep_only_version_with_appliance(image['md5sum'], appliance)
        render('appliance.html', os.path.join('images', image['md5sum'] + '.html'), appliance=image_appliance)

render('appliances.html', os.path.join('appliances', 'index.html'), appliances=appliances)
