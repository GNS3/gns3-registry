#!/bin/sh
# Self-signed certificate for the HTTPS listener.
#
# /etc/nginx is volume-backed by the GNS3 appliance (extra_volumes), so the
# certificate persists across restarts. Lifecycle rules:
#
#   - no certificate yet            -> generate (self-signed)
#   - our own certificate           -> regenerate only when the desired SANs
#                                      changed (primary IP moved, CERT_SAN set)
#   - externally provided cert      -> never touched (replace server.crt +
#                                      server.key in /etc/nginx/certs via the
#                                      node file manager, restart the node)
#
# "Our own" is tracked via a fingerprint marker (.auto-generated): a foreign
# certificate is detected by fingerprint mismatch and left alone from then on.
#
# SAN sources: fixed base + primary container IP (auto-detected) + optional
# CERT_SAN environment variable (comma-separated openssl SAN entries, e.g.
# "IP:192.168.1.50,DNS:lab.gns3.local", settable in the node environment).
set -e

CERT_DIR="/etc/nginx/certs"
CERT_FILE="$CERT_DIR/server.crt"
KEY_FILE="$CERT_DIR/server.key"
MARKER_FILE="$CERT_DIR/.auto-generated"
SANS_RECORD="$CERT_DIR/.generated-sans"

BASE_SANS="DNS:gns3-web-ui,DNS:localhost,IP:127.0.0.1"

PRIMARY_IP=$(hostname -i 2>/dev/null | awk '{print $1}')
if [ -z "$PRIMARY_IP" ] || [ "$PRIMARY_IP" = "127.0.0.1" ]; then
    PRIMARY_IP=$(ip -4 route get 1 2>/dev/null | awk '{for (i = 1; i <= NF; i++) if ($i == "src") print $(i+1)}' | head -1)
fi

DESIRED_SANS="$BASE_SANS"
if [ -n "$PRIMARY_IP" ]; then
    DESIRED_SANS="$DESIRED_SANS,IP:$PRIMARY_IP"
fi
if [ -n "$CERT_SAN" ]; then
    DESIRED_SANS="$DESIRED_SANS,$CERT_SAN"
fi

generate() {
    mkdir -p "$CERT_DIR"
    openssl req -x509 -nodes -newkey rsa:2048 -days 825 \
        -keyout "$KEY_FILE" \
        -out "$CERT_FILE" \
        -subj "/CN=gns3-web-ui" \
        -addext "subjectAltName=$DESIRED_SANS"
    chmod 600 "$KEY_FILE"
    md5sum "$CERT_FILE" | awk '{print $1}' > "$MARKER_FILE"
    echo "$DESIRED_SANS" > "$SANS_RECORD"
    echo "Generated self-signed certificate (SANs: $DESIRED_SANS)"
}

use_external() {
    rm -f "$MARKER_FILE" "$SANS_RECORD"
    echo "Using externally provided certificate in $CERT_DIR"
}

if [ -f "$CERT_FILE" ] && [ -f "$KEY_FILE" ]; then
    if [ ! -f "$MARKER_FILE" ]; then
        use_external
        exit 0
    fi
    CURRENT_FP=$(md5sum "$CERT_FILE" | awk '{print $1}')
    if [ "$CURRENT_FP" != "$(cat "$MARKER_FILE")" ]; then
        # certificate was replaced externally; hands off from now on
        use_external
        exit 0
    fi
    # still our own certificate: regenerate only if the desired SANs changed
    if [ "$(cat "$SANS_RECORD" 2>/dev/null)" = "$DESIRED_SANS" ]; then
        exit 0
    fi
fi

generate
