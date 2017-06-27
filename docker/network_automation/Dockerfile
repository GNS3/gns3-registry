# docker base image for Netmiko, NAPALM, Pyntc, and Ansible

FROM ubuntu:xenial

RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get -y --no-install-recommends install \
    telnet curl openssh-client nano vim-tiny iputils-ping python build-essential libssl-dev libffi-de \
    python-pip ansible \
    && rm -rf /var/lib/apt/lists/* \
    && pip install cryptography netmiko napalm pyntc

VOLUME [ "/root" ]
CMD [ "sh", "-c", "cd; exec bash -i" ]

