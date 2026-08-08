# gns3/frr

Docker image for [FRRouting (FRR)](https://frrouting.org) intended to run as a
GNS3 **Docker router node**. It boots into a working routing stack and drops the
GNS3 console straight into `vtysh`.

## What's inside

- Base: `debian:trixie-slim` (Debian 13, current stable) + FRR from Debian main
  (`frr` 10.3). A domestic apt mirror is available opt-in via `APT_MIRROR` (see Build);
  the Dockerfile also documents how to switch to upstream `frr-stable` (latest 10.x)
  via `deb.frrouting.org`.
- Daemons enabled by default: **zebra, bgpd, ospfd, ospf6d** (edit
  `/etc/frr/daemons` to enable more, e.g. `ripd`, `isisd`, `pimd`, `bfdd`).
- Integrated vtysh config (`service integrated-vtysh-config`).
- `/usr/lib/frr/docker-start` — GNS3-tailored start: enables forwarding, starts
  the daemons under `watchfrr`, then hands the console to a login shell whose
  `/root/.profile` launches `vtysh`.

## Build

```bash
cd docker/frr
docker build -t gns3/frr .
```

Use it from the `FRR (Docker)` appliance (`appliances/frr-docker.gns3a`), which
references `gns3/frr:latest`.

### Domestic (China) mirror — optional

Pass `APT_MIRROR` to fetch every apt package (including `frr`) from a China mirror
instead of the official Debian sources. Any host that serves both `/debian` and
`/debian-security` works:

```bash
# Tsinghua (tuna)
docker build --build-arg APT_MIRROR=mirrors.tuna.tsinghua.edu.cn -t gns3/frr .
# USTC
docker build --build-arg APT_MIRROR=mirrors.ustc.edu.cn -t gns3/frr .
# Aliyun
docker build --build-arg APT_MIRROR=mirrors.aliyun.com -t gns3/frr .
```

Leave `APT_MIRROR` unset (default) to build against the official Debian sources.

## Running standalone (outside GNS3)

```bash
docker run -it --rm --privileged gns3/frr
```

You land in `vtysh`. Type `exit` for a shell, `vtysh` to return.

## Notes / gotchas

- **Console model.** GNS3 attaches the telnet console to the container's PID 1,
  so the start script runs the daemons in the background (under `watchfrr`) and
  keeps an interactive login shell in the foreground. Exiting the shell stops the
  node, just like other GNS3 Docker appliances.
- **Config persistence.** `/etc/frr` is kept across `stop`/`start` (the container
  is reused). It is reset only on node `reset`/`delete` (container recreation),
  because v4 appliances do not support `extra_volumes`. Save running configs with
  `write memory` from `vtysh`; they survive restarts within the node's lifetime.
- **Bridge forwarding on the host.** Direct Docker↔Docker links in GNS3 are
  bridged in userspace by uBridge and do **not** traverse host netfilter, so
  they are unaffected by `bridge-nf-call`. The classic `bridge-nf-call`/FORWARD
  DROP gotcha only bites when traffic crosses a **kernel bridge segment** — e.g.
  FRR ↔ builtin Ethernet Switch / Cloud / NAT. If peers behind such a segment
  fail to establish adjacencies, disable the three `bridge-nf-call` sysctls:
  ```bash
  sysctl -w net.bridge.bridge-nf-call-ip6tables=0
  sysctl -w net.bridge.bridge-nf-call-iptables=0
  sysctl -w net.bridge.bridge-nf-call-arptables=0
  ```
