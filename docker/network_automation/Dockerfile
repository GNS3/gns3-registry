# docker base image for Netmiko, NAPALM, Pyntc, and Ansible

FROM ubuntu:xenial

RUN DEBIAN_FRONTEND=noninteractive apt-add-repository -y ppa:ansible/ansible && apt-get update && \
    apt-get -y --no-install-recommends install telnet curl openssh-client nano vim-tiny \
    iputils-ping python build-essential libssl-dev libffi-dev python-pip python-setuptools \
    python-dev net-tools ansible python3 software-properties-common \
    && rm -rf /var/lib/apt/lists/* \
    && pip install --upgrade pip \
    && pip install cryptography netmiko napalm pyntc

VOLUME [ "/root" ]
CMD [ "sh", "-c", "cd; exec bash -i" ]

