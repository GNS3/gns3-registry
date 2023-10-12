#!/usr/bin/env python3
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
import json
import signal
import sys
import pycurl

err_list = []


def handle_ctrl_c(signal, frame):
    print("Got Ctrl-C, terminating!")
    sys.exit(1)
signal.signal(signal.SIGINT, handle_ctrl_c)


def data_abort(data):
    return -1


def check_url(url, appliance):
    print("   " + url)

    error = None
    c = pycurl.Curl()
    try:
        c.setopt(c.URL, url)
        c.setopt(pycurl.CONNECTTIMEOUT, 30)
        c.setopt(c.USERAGENT, 'Mozilla/5.0 (compatible; MSIE 10.0; Windows NT 6.1; Trident/6.0)')
        c.setopt(c.HTTPHEADER, ['Accept-Language: en-us'])
        c.setopt(c.FOLLOWLOCATION, True)
        c.setopt(c.WRITEFUNCTION, data_abort)
        c.perform()
    except pycurl.error as err:
        errno, errstr = err.args
        if errno != pycurl.E_WRITE_ERROR:
            error = errstr

    if not error:
        http_status = c.getinfo(c.RESPONSE_CODE)
        if http_status >= 400:
            error = 'HTTP status {}'.format(http_status)

    if error:
        print("     " + error)
        err_list.append("{}: {} - {}".format(appliance, url, error))

    c.close()


def check_urls(appliance):
    try:
        with open(os.path.join('appliances', appliance)) as f:
            appliance_json = json.load(f)
    except Exception as err:
        print("   " + str(err))
        err_list.append("{}: {}".format(appliance, err))
        return []

    urls = set()

    if 'images' in appliance_json:
        for image in appliance_json['images']:
            if 'direct_download_url' in image:
                urls.add(image['direct_download_url'])
            if 'download_url' in image:
                urls.add(image['download_url'])

    if 'vendor_url' in appliance_json:
        urls.add(appliance_json['vendor_url'])
    if 'vendor_logo_url' in appliance_json:
        urls.add(appliance_json['vendor_logo_url'])
    if 'documentation_url' in appliance_json:
        urls.add(appliance_json['documentation_url'])
    if 'product_url' in appliance_json:
        urls.add(appliance_json['product_url'])
    return list(urls)


def main():
    print("=> Check URL in appliances")
    if len(sys.argv) >= 2:
        appliance_list = sys.argv[1:]
    else:
        appliance_list = os.listdir('appliances')
        appliance_list.sort()

    for appliance in appliance_list:
        if not appliance.endswith('.gns3a'):
            appliance += '.gns3a'
        print("-> {}".format(appliance))
        for url in check_urls(appliance):
            check_url(url, appliance)
        print()

    if len(err_list) == 0:
        print("Everything is ok!")
    else:
        print("{} error(s):".format(len(err_list)))
        for error in err_list:
            print(error)

if __name__ == '__main__':
    main()
