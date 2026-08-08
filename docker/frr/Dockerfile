# GNS3 Docker image for FRRouting (FRR)
#
# Runs the FRR routing stack (zebra + bgpd + ospfd + ospf6d by default) supervised
# by watchfrr, and exposes vtysh on the GNS3 telnet console. Designed to run as a
# GNS3 Docker router node: the start script (/usr/lib/frr/docker-start) brings the
# daemons up and then hands the console to a login shell whose .profile launches
# vtysh, so the operator lands directly in the routing CLI.

FROM debian:trixie-slim

ENV DEBIAN_FRONTEND=noninteractive

# Domestic (China) apt mirror is opt-in via build arg, e.g.
#   docker build --build-arg APT_MIRROR=mirrors.tuna.tsinghua.edu.cn -t gns3/frr .
# Leave unset to use the official Debian sources. Any mirror host that serves both
# /debian and /debian-security works (tuna / ustc / aliyun ...).
ARG APT_MIRROR=""
RUN if [ -n "$APT_MIRROR" ]; then \
        echo "Switching apt mirror to $APT_MIRROR"; \
        sed -i \
            -e "s|deb.debian.org|$APT_MIRROR|g" \
            -e "s|security.debian.org|$APT_MIRROR|g" \
            /etc/apt/sources.list.d/debian.sources /etc/apt/sources.list 2>/dev/null || true; \
    fi

# FRR ships in Debian main (trixie = frr 10.3), so every package — including
# frr itself — is fetched from the mirror above, with no foreign-repo dependency.
# To track upstream frr-stable (latest 10.x) instead, uncomment this block:
#
#   RUN apt-get update && apt-get install -y --no-install-recommends gnupg2 lsb-release curl ca-certificates \
#    && curl -fsSL https://deb.frrouting.org/frr/keys.asc | gpg --dearmor -o /usr/share/keyrings/frrouting.gpg \
#    && echo "deb [signed-by=/usr/share/keyrings/frrouting.gpg] https://deb.frrouting.org/frr $(lsb_release -s -c) frr-stable" \
#        > /etc/apt/sources.list.d/frr.list
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        curl ca-certificates procps iproute2 net-tools iputils-ping less tini \
        frr frr-pythontools \
    && rm -rf /var/lib/apt/lists/*

# runtime dirs and permissions
RUN mkdir -p /var/run/frr \
    && chown -R frr:frr /etc/frr /var/run/frr

# enable the default daemon set (zebra, bgpd, ospfd, ospf6d) + integrated vtysh
# config, by flipping the package-shipped /etc/frr/daemons (version-agnostic).
RUN sed -i -E '/^(zebra|bgpd|ospfd|ospf6d)=/ s/= *no/=yes/' /etc/frr/daemons \
    && sed -i -E '/^vtysh_enable=/ s/= *no/=yes/' /etc/frr/daemons \
    && printf 'service integrated-vtysh-config\n' > /etc/frr/vtysh.conf \
    && chown frr:frr /etc/frr/daemons /etc/frr/frr.conf /etc/frr/vtysh.conf \
    && chmod 640 /etc/frr/*

# the GNS3 telnet console attaches to PID 1's stdin/stdout; give it a login shell
# that auto-launches vtysh (mirrors the QEMU FRR appliance UX).
RUN printf '%s\n' \
    'export VTYSH_PAGER="less -M -i -EFX"' \
    '# let the daemons settle before vtysh attaches' \
    'sleep 1' \
    'vtysh' \
    > /root/.profile

COPY docker-start /usr/lib/frr/docker-start
RUN chmod +x /usr/lib/frr/docker-start

USER root

# Default entrypoint for standalone use (GNS3 execs start_command directly).
ENTRYPOINT ["/usr/bin/tini", "--"]
CMD ["/usr/lib/frr/docker-start"]
