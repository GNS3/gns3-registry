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


import pytest
import urllib.request
import tempfile
import os

@pytest.fixture
def linux_microcore_img():

    path = os.path.join(tempfile.tempdir, "linux-microcore-3.4.1.img")
    if not os.path.exists(path):
        urllib.request.urlretrieve("http://downloads.sourceforge.net/project/gns-3/Qemu%20Appliances/linux-microcore-3.4.1.img?r=&ts=1432209459&use_mirror=heanet", path)
    return path


@pytest.fixture
def empty_file(tmpdir):

    path = str(tmpdir / "a")
    open(path, "w+").close()
    return path
