FROM phusion/baseimage:0.9.22

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

# Tell debconf to run in non-interactive mode
ENV DEBIAN_FRONTEND noninteractive


ENV PYCHARM_HOME=/etc/pycharm
RUN apt-get update && apt-get -y --no-install-recommends install \
    wget  \
    git \
    openjdk-9-jre \
    libxrender1 \
    libxtst6 \
    python \
    python3 \
    curl \
    openssh-client \
    nano \
    vim \
    iputils-ping \
    python \
    build-essential \
    libssl-dev \
    libffi-dev \
    python-pip \
    python-setuptools \
    python3-setuptools \
    python-dev \
    net-tools \
    telnet \
    software-properties-common \
    && apt-add-repository -y ppa:ansible/ansible \
    && apt-get update && apt-get -y --no-install-recommends install ansible \
    && pip install --upgrade pip \
    && pip install cryptography netmiko napalm pyntc \
    && pip install --upgrade paramiko \
    && pip install pexpect \
    && pip install docopt==0.6.2 sh

RUN export JAVA_HOME=/usr/lib/jvm/default-java

RUN wget https://download.jetbrains.com/python/pycharm-community-2017.2.3.tar.gz

RUN mkdir ${PYCHARM_HOME} && tar -xzvf pycharm-community-2017.2.3.tar.gz -C ${PYCHARM_HOME} --strip=1 &&\
    wget -P /tmp/ https://bootstrap.pypa.io/get-pip.py && python /tmp/get-pip.py &&\
    rm -rf /var/lib/apt-lists; rm -rf /tmp/*; apt-get purge wget -y; apt-get autoremove -y
RUN mkdir /scripts
RUN mkdir /etc/sv/pycharm
ADD pycharm-run /etc/sv/pycharm/run
RUN chmod a+x /etc/sv/pycharm/run
RUN ln -s /etc/sv/pycharm /etc/service

VOLUME ["/root", "/usr/", "/scripts"]
