FROM alpine:3.22

LABEL maintainer="developers@gns3.net"

RUN apk add --no-cache \
    openssh \
    mtr \
    nmap \
    iperf \
    socat \
    vim \
    nano \
    curl \
    links \
    iputils \
    bind-tools \
    rsync \
    bash

VOLUME ["/root/.ssh", "/etc/ssh", "/data"]

COPY start-ssh.sh /bin/start-ssh.sh
RUN chmod +x /bin/start-ssh.sh

CMD ["/bin/start-ssh.sh"]
