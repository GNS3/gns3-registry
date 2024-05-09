FROM ubuntu:jammy

WORKDIR /pyats

RUN apt update
RUN apt install -y nano
RUN apt install -y net-tools
RUN apt install -y openssh-client
RUN echo KexAlgorithms diffie-hellman-group14-sha1 >> /etc/ssh/ssh_config
RUN echo HostKeyAlgorithms ssh-rsa >> /etc/ssh/ssh_config
RUN apt install -y python3
RUN apt install -y python3-pip
RUN apt install -y traceroute
RUN apt install -y iputils-ping
RUN python3 -m pip install --upgrade pip wheel setuptools
RUN python3 -m pip install "pyats[full]"

ENTRYPOINT [ "/bin/bash" ]
