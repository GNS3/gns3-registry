# Web Wireshark Docker Image

## Overview

Docker image for Web Wireshark - provides browser-based packet capture viewing using xpra HTML5 client and Wireshark.

## Features

- **xpra HTML5 client** - Browser-based VNC alternative with HTML5 frontend
- **Wireshark** - Network protocol analyzer for packet capture
- **Custom background** - GNS3 branded background with gradient styling
- **Optimized defaults** - Disabled unused features for better security

## Container Features

| Feature | Status | Description |
|---------|--------|-------------|
| File Transfer | Disabled | Prevents file upload/download |
| Printing | Disabled | No printer forwarding |
| Sound | Disabled | No audio forwarding |
| Fullscreen Button | Hidden | Cleaner interface |

## Build

```bash
docker build -t gns3/web-wireshark:latest .
```

## Environment Variables

| Variable | Value | Description |
|----------|-------|-------------|
| DEBIAN_FRONTEND | noninteractive | Skip apt prompts |
| LANG | C.UTF-8 | UTF-8 locale |
| LC_ALL | C.UTF-8 | UTF-8 locale |
| XDG_RUNTIME_DIR | /run/user/1000 | Runtime directory |

## Ports

Dynamic - xpra binds to TCP port specified at runtime (typically 10000-19999 based on link ID).

## Usage

This image is used by GNS3 Web Wireshark integration. Sessions are started via the `manage_wireshark.py` script which handles:

1. Container lifecycle (create/start/stop/delete)
2. xpra session management
3. Wireshark launch with capture stream

## XPra Command Options

Key xpra options used:

```
xpra start :{display}
  --xvfb="Xvfb -screen 0 1920x1080x24 +extension RANDR"
  --html=on
  --bind-tcp=0.0.0.0:{port}
  --dpi=96
  --daemon=yes
  --dbus-launch=no
  --resize-display=yes
  XPRA_CLIENT_CAN_SHUTDOWN=false
```

## Customization

### Background Image

The GNS3 icon SVG is used as background. To customize:

1. Replace `/usr/share/xpra/www/background.svg`
2. Modify `/usr/share/xpra/www/css/client.css` for CSS changes

### HTML5 Client Settings

Edit `/usr/share/xpra/www/default-settings.txt` to change client defaults:

```
file_transfer=false
printing=false
sound=false
fullscreen_button=false
```

## Security Notes

- Runs as non-root user `gns3` (UID 1000)
- File transfer and printing disabled
- Shutdown menu hidden from HTML5 client
- No exposure of sensitive ports

## Base Image

- **Debian Trixie** (13) - Latest stable Debian

## License

GPL-3.0-or-later - See LICENSE file
