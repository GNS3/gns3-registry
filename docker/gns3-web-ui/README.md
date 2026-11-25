# GNS3 Web UI Docker Image

## Purpose

This image is a **development and testing tool**. It is meant to run as a
GNS3 appliance node inside a **GNS3 server project topology**, together with
the companion appliance file [`appliances/gns3-web-ui.gns3a`](../../appliances/gns3-web-ui.gns3a)
(which references the `gns3/gns3-web-ui` image this README describes). It is
not part of a production GNS3 deployment — in production, use the Web UI
bundled with the GNS3 server.

## Overview

Pure runtime shell for the GNS3 Web UI: nginx serves the Web UI build artifact
over HTTP (80) and HTTPS (443, self-signed certificate generated at first
startup) and reverse-proxies the controller API (`/v3`, including WebSockets)
to a GNS3 controller, so the browser only ever talks to this container
(same-origin, no CORS configuration on the controller).

The image NEVER contains a Web UI build — it is a template shell only. Builds
(version builds, PR builds) are supplied **at runtime** through the persistent
`/srv/ui` volume: deploying a build simply **replaces the contents of
`/srv/ui`**. Swapping versions never requires rebuilding the image, and the
version history lives on the build side (`ui-versions/` in the web-ui repo
workflow), not in the container.

## Layout

```
docker/gns3-web-ui/
├── Dockerfile
├── README.md
└── runtime/
    ├── nginx-templates/default.conf.template   # envsubst'ed at every startup
    └── entrypoint.d/40-generate-self-signed-cert.sh
```

## Build

No Web UI build artifact is involved — the image is built from this directory
alone:

```bash
cd docker/gns3-web-ui
docker build -t gns3/gns3-web-ui:latest .
```

Building with the `gns3/gns3-web-ui` tag means a locally existing image is
used by GNS3 without pulling. Until a build is uploaded through the node's
file manager, the container serves a placeholder page.

## Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `CONTROLLER_URL` | `http://host.docker.internal:3080` | Controller (gns3server) address. **Edit in the node environment after creating the node** — set it to the address your server is reachable at from the topology network (e.g. `http://192.168.122.1:3080` with the NAT node, or the host address on the interface a Cloud node bridges). The server must listen on it. **Never rename this variable to a `GNS3_*` name**: the GNS3 server silently drops user environment variables whose name starts with `GNS3_` (reserved for its own init.sh knobs), so such a value would never reach the container. |
| `CERT_SAN` | *(unset)* | Extra openssl SAN entries appended to the certificate, comma-separated, e.g. `IP:192.168.1.50,DNS:lab.gns3.local`. |

## Server compatibility

- **gns3-server ≥ PR #3104** (3.1, commit `83d00aec4`): extra_hosts values are
  validated as `hostname:IP` pairs — the docker special value `host-gateway`
  is rejected. This appliance/template uses the plain IP `172.17.0.1` and
  complies.
- **Older servers**: extra_hosts are forwarded verbatim into `/etc/hosts`,
  where `172.17.0.1` is a valid entry, so it works unchanged. The entrypoint
  script additionally repairs `/etc/hosts` lines containing the literal
  `host-gateway` left behind by nodes created with old templates.

## Ports

| Port | Description |
|------|-------------|
| 80   | Web UI (HTTP) and same-origin controller proxy |
| 443  | Same, over HTTPS with a self-signed certificate |

### Certificate lifecycle (`runtime/entrypoint.d/`)

SANs = fixed base (`DNS:gns3-web-ui`, `DNS:localhost`, `IP:127.0.0.1`) +
primary container IP (auto-detected at generation time) + `CERT_SAN` extras.

- No certificate yet → self-signed one is generated. Because `/etc/nginx` is
  volume-backed in the GNS3 appliance, it persists across restarts.
- Own certificate, desired SANs unchanged (IP moved? `CERT_SAN` changed?) →
  kept; regenerated automatically when they change.
- Externally provided certificate → never touched. To install a valid
  certificate, upload `server.crt` + `server.key` into `/etc/nginx/certs`
  (node file manager or server file API) and restart the node. Detection is
  fingerprint-based (a `.auto-generated` marker): no marker file needs to be
  deleted by hand.

Self-signed certificates always show a browser trust warning; proceed once
per browser per certificate.

## Controller registration in the Web UI

Register the controller as **this container itself**: Host = the address used
to reach the container, Port = `80` (or `443`). API, login and WebSocket
traffic are proxied to `CONTROLLER_URL` server-side; the real controller
address is never exposed to the browser.

Note: because the proxy is same-origin, one container instance serves exactly
one controller. Run one instance per controller (different ports or hosts) to
work with several controllers.

## Deploying / swapping a build

The served files live directly in the persistent `/srv/ui` volume — a plain
directory on the compute host (bind-mounted into the container). Deploying a
build is a manual copy-paste on the host:

```bash
# the volume backing directory (one per node; see how to look it up below)
D=<project-files>/docker/<node-id>/srv/ui

rm -rf "$D"/* && cp -r <path-to-web-ui>/dist/browser/. "$D"/

# verify
curl http://<node-ip>/VERSION.txt
```

- Effective immediately (nginx resolves the path per request), no restart;
  persists across node restarts and image rebuilds.
- `rm -rf "$D"/*` does not match dotfiles, so the `.gns3_perms` seeding
  marker survives.
- Look up the backing directory for a node:

```bash
docker inspect <node-container> --format \
  '{{range .Mounts}}{{if eq .Destination "/gns3volumes/srv/ui"}}{{.Source}}{{end}}{{end}}'
```

- If the compute runs on a remote machine, copy to the same path there
  (`scp`/`rsync`) instead.

Alternative (local compute): `docker cp <build>/. <node>:/gns3volumes/srv/ui/`
— the `/gns3volumes/srv/ui` path is the same volume backing directory seen
from inside the container. Do **not** copy into `/srv/ui/` itself: it is a
bind mount created inside the container by init.sh, and `docker cp` does not
traverse container-namespace mounts — files silently land in a shadowed
overlay path while docker reports success.

When a GNS3 appliance mounts `/srv/ui` as an `extra_volumes` entry, seeding
from the image happens on **first boot only** (it seeds the placeholder
page). A populated volume is never updated by newer images — upload files or
clear the volume to re-seed.

`index.html` is served with `Cache-Control: no-cache`; hashed asset filenames
make swaps safe without browser cache busting.

## Nginx configuration persistence

The appliance also mounts `/etc/nginx` as a persistent volume. The editable
surface is `/etc/nginx/templates/*.template`: environment variables in it
(like `${CONTROLLER_URL}`) are substituted at **every** startup, and edits
persist. Do not edit the regenerated output files (for example
`/etc/nginx/conf.d/default.conf`) — envsubst rewrites them at each startup
from the template, so direct edits there are lost on restart. The same
first-boot-only seeding caveat applies: updating the image does not update an
already-populated config volume.

## Version information

The web-ui build script writes `VERSION.txt` (for example
`3.1.0.dev8+fb53938a`) into the artifact directory; after upload it ends up at
`/srv/ui/VERSION.txt`, served at `/VERSION.txt`, and can be checked from the
container console.

## Related appliance

`appliances/gns3-web-ui.gns3a` registers this image as a GNS3 appliance
(`settings[].template_type: "docker"`,
`extra_volumes: ["/srv/ui", "/etc/nginx"]`).
