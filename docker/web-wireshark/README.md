# Web Wireshark Docker Image

## Overview

Docker image for Web Wireshark - provides browser-based packet capture viewing using xpra HTML5 client and Wireshark.

## Features

- **xpra HTML5 client** - Browser-based VNC alternative with HTML5 frontend (version 6.4.3)
- **Wireshark** - Network protocol analyzer for packet capture
- **Non-root user** - Runs as gns3 user (UID 1000) for better security

## Build

```bash
docker build -t gns3/web-wireshark:latest .
```

## Environment Variables

| Variable | Value | Description |
|----------|-------|-------------|
| DEBIAN_FRONTEND | noninteractive | Skip apt prompts |
| TZ | UTC | Timezone |
| LANG | C.UTF-8 | UTF-8 locale |
| LC_ALL | C.UTF-8 | UTF-8 locale |
| XDG_RUNTIME_DIR | /run/user/1000 | Runtime directory |

## Ports

Dynamic - Port will be dynamically allocated at runtime by GNS3.

## Usage

This image is used by GNS3 Web Wireshark integration. The container runs with `tail -f /dev/null` to stay alive and is managed by GNS3 which handles:

1. Container lifecycle (create/start/stop/delete)
2. xpra session management
3. Wireshark launch with capture stream

## Security Notes

- Runs as non-root user `gns3` (UID 1000)
- Sessions directory at `/tmp/sessions` with proper permissions (1777)

## Base Image

- **Debian Trixie** (13) - Latest stable Debian

## License

GPL-3.0-or-later - See LICENSE file
