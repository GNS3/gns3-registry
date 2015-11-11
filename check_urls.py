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
import json
import sys
import socket
import time
import urllib.request
from multiprocessing import Pool

class CheckError(Exception):
    def __init__(self, m):
        self.message = m

    def __str__(self):
        return self.message


class MyHTTPRedirectHandler(urllib.request.HTTPRedirectHandler):
    def redirect_request(self, req, fp, code, msg, hdrs, newurl):
        return None


urllib.request.install_opener(urllib.request.build_opener(MyHTTPRedirectHandler))


def check_url(args):
    url, appliance = args
    print("Check " + url)

    remaining_failure = 5
    error = None
    while remaining_failure != 0:
        try:
            req = urllib.request.Request(url, method='HEAD')
            req.add_header
            urllib.request.urlopen(req, timeout=45) #Yeah a big big timeout for broken websites...
        except urllib.error.HTTPError as err:
            if err.getcode() >= 400:
                error = CheckError('Error with url {} ({})'.format(url, str(err)))
            else:
                # We allow error code like 302
                return
        except urllib.error.URLError as err:
            error = CheckError('Invalid URL {} ({})'.format(url, str(err)))
        except socket.timeout as err:
            error = CheckError('Timeout URL {} ({})'.format(url, str(err)))
        else:
            return
        remaining_failure -= 1
        time.sleep(5)
    raise error


def check_urls(pool, appliance):
    with open(os.path.join('appliances', appliance)) as f:
        appliance_json = json.load(f)

    calls = []

    for image in appliance_json['images']:
        if 'direct_download_url' in image:
            calls.append((image['direct_download_url'], appliance))
        if 'download_url' in image:
            calls.append((image['download_url'], appliance))

    if 'vendor_url' in appliance_json:
        calls.append((appliance_json['vendor_url'], appliance))
    if 'documentation_url' in appliance_json:
        calls.append((appliance_json['documentation_url'], appliance))
    if 'product_url' in appliance_json:
        calls.append((appliance_json['product_url'], appliance))
    return calls


def main():
    pool = Pool(processes=8)

    calls_check_url = []
    for appliance in os.listdir('appliances'):
        calls_check_url += check_urls(pool, appliance)
    print("=> Check URL in appliances")
    try:
        pool.map_async(check_url, calls_check_url).get()
    except CheckError as e:
        print(e)
        sys.exit(1)
    pool.close()
    pool.join()
    print("Everything is ok!")

if __name__ == '__main__':
    main()
