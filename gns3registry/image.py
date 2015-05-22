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

import hashlib


class Image:
    """
    A disk image
    """

    def __init__(self, path):
        """
        :params: path of the image
        """
        self._path = path
        self._sha1sum = None
        self._version = None

    @property
    def path(self):
        """
        :returns: Image path
        """
        return self._path

    @property
    def version(self):
        """
        :returns: Get the file version / release
        """
        return self._version

    @version.setter
    def version(self, version):
        """
        :returns: Set the file version / release
        """
        self._version = version

    @property
    def sha1sum(self):
        """
        Compute a sha1 hash for file

        :returns: hexadecimal sha1
        """

        if self._sha1sum is None:
            m = hashlib.sha1()
            with open(self._path, "rb") as f:
                while True:
                    buf = f.read(128)
                    if not buf:
                        break
                    m.update(buf)
            self._sha1sum = m.hexdigest()
        return self._sha1sum


