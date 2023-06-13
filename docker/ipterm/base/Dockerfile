# docker base image for basic networking tools

## Stage 1 - compile mtools (msend & mreceive)
FROM debian:bookworm-slim

RUN set -e -x \
    && cd /root \
    && export DEBIAN_FRONTEND=noninteractive \
    && apt-get update \
    && apt-get -y --no-install-recommends install \
        gcc libc6-dev make curl ca-certificates \
    && curl -s -S -L -O https://github.com/troglobit/mtools/releases/download/v2.3/mtools-2.3.tar.gz \
    && tar xfz mtools-2.3.tar.gz \
    && cd mtools-2.3 \
    && make \
    && make install

## Stage 2 - Main image
FROM debian:bookworm-slim

COPY --from=0 /usr/local/sbin/* /usr/local/bin/

RUN set -e -x \
    && export DEBIAN_FRONTEND=noninteractive \
    && apt-get update \
    && apt-get -y --no-install-recommends install \
        dumb-init curl ca-certificates iperf3 knot-host \
        mtr-tiny openssh-client socat tcpdump \
        net-tools iproute2 ifupdown iputils-ping \
        telnet traceroute procps nano vim-tiny \
    && ln -s /usr/bin/khost /usr/local/bin/host \
    && rm -rf /var/lib/apt/lists/*
