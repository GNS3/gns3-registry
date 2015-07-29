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
os.mkdir(os.path.join('build', 'devices'))
os.mkdir(os.path.join('build', 'images'))


def render(template_file, out, **kwargs):
    log.info('Build %s', out)
    env = Environment(loader=FileSystemLoader('templates'))
    env.filters['jsonify'] = json.dumps
    env.filters['escape_quote'] = lambda x: x.replace('"','\\"')
    template = env.get_template(template_file)
    template.stream(**kwargs).dump(os.path.join('build', out))


render('index.html', 'index.html')


devices = []
for file in os.listdir('devices'):
    filename = file[:-5]
    with open(os.path.join('devices', file)) as f:
        device = json.load(f)
    device['id'] = filename
    render('device.html', os.path.join('devices', filename + '.html'), device=device)
    devices.append(device)


    for image_type in device['images']:
        for image in device['images'][image_type]:
            # We keep only this image in the page
            image_device = device
            image_device['images'][image_type] = [ image ]
            render('device.html', os.path.join('images', image['md5sum'] + '.html'), device=image_device)

render('devices.html', os.path.join('devices', 'index.html'), devices=devices)
