# Ubuntu Docker base image with basic networking tools installed

FROM ubuntu:noble

RUN DEBIAN_FRONTEND=noninteractive apt update && apt -y --no-install-recommends install \
    net-tools  \
    iproute2 \
    tcpdump \
    telnet \
    traceroute \
    curl \
    iperf3 \
    knot-host \
    openssh-client \
    mtr-tiny \
    socat \
    nano \
    nmap \
    iputils-ping \
    && rm -rf /var/lib/apt/lists/*

VOLUME [ "/root" ]
CMD [ "sh", "-c", "cd; exec bash -i" ]
