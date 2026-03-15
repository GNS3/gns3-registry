# AlpiNet - Lightweight Alpine-based networking toolbox for GNS3
FROM alpine:3.23

# Metadata
LABEL maintainer="nazDridoy <nazdridoy399@gmail.com>"
LABEL description="Lightweight Alpine-based networking toolbox for GNS3"
LABEL version="1.4.0-alp3.23"

# Install essential networking and system utilities
RUN apk --no-cache add \
    # Core networking tools
    iproute2 \
    iputils \
    bind-tools \
    tcpdump \
    nmap \
    curl \
    wget \
    openssh-client \
    net-tools \
    iperf3 \
    mtr \
    socat \
    netcat-openbsd \
    traceroute \
    bridge-utils \
    vlan \
    ethtool \
    # Firewall tools
    iptables \
    ip6tables \
    nftables \
    # File transfer clients
    lftp \
    tftp-hpa \
    # System utilities
    bash \
    bash-completion \
    nano \
    less \
    tmux \
    screen \
    htop \
    procps \
    util-linux \
    coreutils \
    grep \
    sed \
    gawk \
    findutils \
    # Network testing
    iperf \
    # Web browsers
    lynx \
    # Additional utilities
    ca-certificates \
    openssl \
    tzdata \
    jq \
    tree \
    file \
    rsync \
    tar \
    gzip \
    dumb-init \
    busybox-extras

# Set bash as default shell
RUN sed -i 's|/bin/ash|/bin/bash|g' /etc/passwd

# Set up bash configuration
RUN echo 'PS1="\[\e[1;32m\]\u@\h\[\e[0m\]:\[\e[1;34m\]\w\[\e[0m\]# "' >> /root/.bashrc && \
    echo 'alias ll="ls -lah"' >> /root/.bashrc && \
    echo 'alias la="ls -A"' >> /root/.bashrc && \
    echo 'alias l="ls -CF"' >> /root/.bashrc

# Create a welcome message
RUN echo '#!/bin/bash' > /etc/profile.d/motd.sh && \
    echo 'cat << "EOF"' >> /etc/profile.d/motd.sh && \
    echo '      .o.       oooo              o8o  ooooo      ooo               .   ' >> /etc/profile.d/motd.sh && \
    echo '     .888.      `888              `"'\''  `888b.     `8'\''             .o8   ' >> /etc/profile.d/motd.sh && \
    echo '    .8"888.      888  oo.ooooo.  oooo   8 `88b.    8   .ooooo.  .o888oo ' >> /etc/profile.d/motd.sh && \
    echo '   .8'\'' `888.     888   888'\'' `88b `888   8   `88b.  8  d88'\'' `88b   888   ' >> /etc/profile.d/motd.sh && \
    echo '  .88ooo8888.    888   888   888  888   8     `88b.8  888ooo888   888   ' >> /etc/profile.d/motd.sh && \
    echo ' .8'\''     `888.   888   888   888  888   8       `888  888    .o   888 . ' >> /etc/profile.d/motd.sh && \
    echo 'o88o     o8888o o888o  888bod8P'\'' o888o o8o        `8  `Y8bod8P'\''   "888" ' >> /etc/profile.d/motd.sh && \
    echo '                       888                                              ' >> /etc/profile.d/motd.sh && \
    echo '                      o888o                                             ' >> /etc/profile.d/motd.sh && \
    echo '                                                                        .' >> /etc/profile.d/motd.sh && \
    echo '' >> /etc/profile.d/motd.sh && \
    echo '  AlpiNet - Lightweight Alpine-based Networking Toolbox' >> /etc/profile.d/motd.sh && \
    echo '  Type "alpinet-tools" for available utilities' >> /etc/profile.d/motd.sh && \
    echo 'EOF' >> /etc/profile.d/motd.sh && \
    chmod +x /etc/profile.d/motd.sh

# Create a helper script to list available tools
RUN echo '#!/bin/bash' > /usr/local/bin/alpinet-tools && \
    echo 'cat << "EOF"' >> /usr/local/bin/alpinet-tools && \
    echo "=== AlpiNet Available Tools ===" >> /usr/local/bin/alpinet-tools && \
    echo "" >> /usr/local/bin/alpinet-tools && \
    echo "NETWORK UTILITIES:" >> /usr/local/bin/alpinet-tools && \
    echo "  • IP/Interface: ip, ifconfig, route, arp" >> /usr/local/bin/alpinet-tools && \
    echo "  • Connectivity: ping, traceroute, mtr, arping" >> /usr/local/bin/alpinet-tools && \
    echo "  • Scanning: nmap, tcpdump" >> /usr/local/bin/alpinet-tools && \
    echo "  • HTTP/Web: curl, wget, lynx" >> /usr/local/bin/alpinet-tools && \
    echo "  • TCP/UDP: netcat (nc), socat, telnet" >> /usr/local/bin/alpinet-tools && \
    echo "  • Performance: iperf, iperf3" >> /usr/local/bin/alpinet-tools && \
    echo "  • Advanced: ethtool, bridge-utils (brctl), vlan (vconfig)" >> /usr/local/bin/alpinet-tools && \
    echo "" >> /usr/local/bin/alpinet-tools && \
    echo "FIREWALL TOOLS:" >> /usr/local/bin/alpinet-tools && \
    echo "  • IPv4: iptables" >> /usr/local/bin/alpinet-tools && \
    echo "  • IPv6: ip6tables" >> /usr/local/bin/alpinet-tools && \
    echo "  • Modern: nftables (nft)" >> /usr/local/bin/alpinet-tools && \
    echo "" >> /usr/local/bin/alpinet-tools && \
    echo "FILE TRANSFER:" >> /usr/local/bin/alpinet-tools && \
    echo "  • FTP: lftp" >> /usr/local/bin/alpinet-tools && \
    echo "  • TFTP: tftp" >> /usr/local/bin/alpinet-tools && \
    echo "  • SSH: ssh, scp, sftp (openssh-client)" >> /usr/local/bin/alpinet-tools && \
    echo "  • Sync: rsync" >> /usr/local/bin/alpinet-tools && \
    echo "" >> /usr/local/bin/alpinet-tools && \
    echo "DNS TOOLS:" >> /usr/local/bin/alpinet-tools && \
    echo "  • Lookup: host, nslookup, dig" >> /usr/local/bin/alpinet-tools && \
    echo "" >> /usr/local/bin/alpinet-tools && \
    echo "EDITORS:" >> /usr/local/bin/alpinet-tools && \
    echo "  • vi, nano" >> /usr/local/bin/alpinet-tools && \
    echo "" >> /usr/local/bin/alpinet-tools && \
    echo "TERMINAL MULTIPLEXERS:" >> /usr/local/bin/alpinet-tools && \
    echo "  • tmux, screen" >> /usr/local/bin/alpinet-tools && \
    echo "" >> /usr/local/bin/alpinet-tools && \
    echo "SYSTEM MONITORING:" >> /usr/local/bin/alpinet-tools && \
    echo "  • Process: htop, top, ps" >> /usr/local/bin/alpinet-tools && \
    echo "  • Resources: free, vmstat" >> /usr/local/bin/alpinet-tools && \
    echo "" >> /usr/local/bin/alpinet-tools && \
    echo "TEXT PROCESSING:" >> /usr/local/bin/alpinet-tools && \
    echo "  • Viewing: less, cat" >> /usr/local/bin/alpinet-tools && \
    echo "  • Search: grep, find" >> /usr/local/bin/alpinet-tools && \
    echo "  • Processing: sed, awk (gawk)" >> /usr/local/bin/alpinet-tools && \
    echo "  • JSON: jq" >> /usr/local/bin/alpinet-tools && \
    echo "" >> /usr/local/bin/alpinet-tools && \
    echo "COMPRESSION/ARCHIVING:" >> /usr/local/bin/alpinet-tools && \
    echo "  • tar, gzip, gunzip" >> /usr/local/bin/alpinet-tools && \
    echo "" >> /usr/local/bin/alpinet-tools && \
    echo "UTILITIES:" >> /usr/local/bin/alpinet-tools && \
    echo "  • tree - directory visualization" >> /usr/local/bin/alpinet-tools && \
    echo "  • file - identify file types" >> /usr/local/bin/alpinet-tools && \
    echo "  • openssl - SSL/TLS toolkit" >> /usr/local/bin/alpinet-tools && \
    echo "" >> /usr/local/bin/alpinet-tools && \
    echo "SHELL:" >> /usr/local/bin/alpinet-tools && \
    echo "  • bash (with completion support)" >> /usr/local/bin/alpinet-tools && \
    echo "" >> /usr/local/bin/alpinet-tools && \
    echo 'EOF' >> /usr/local/bin/alpinet-tools && \
    chmod +x /usr/local/bin/alpinet-tools

# Set working directory
WORKDIR /root

# Create startup script with custom initialization support
# Users can create /root/init.sh for custom startup tasks
RUN printf '#!/bin/sh\n\
    # Re-exec with dumb-init if PID 1\n\
    [ $$ -eq 1 ] && exec dumb-init -- "$0" "$@"\n\
    \n\
    # Run user init script if it exists\n\
    [ -f /root/init.sh ] && [ -x /root/init.sh ] && /root/init.sh\n\
    \n\
    # Change to home directory\n\
    cd\n\
    \n\
    # Execute command or start interactive bash\n\
    if [ $# -gt 0 ]; then\n\
    \t"$@"\n\
    else\n\
    \tbash -i -l\n\
    fi\n' > /etc/alpinet-init.sh && chmod +x /etc/alpinet-init.sh

# Declare /root as a volume for persistence in GNS3
VOLUME ["/root"]

# Use ENTRYPOINT for proper init handling
ENTRYPOINT ["/etc/alpinet-init.sh"]
