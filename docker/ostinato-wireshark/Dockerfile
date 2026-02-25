FROM alpine:3.22

LABEL maintainer="Mark Young <miyoung999@hotmail.com>"

ENV DISPLAY=:99
ENV RESOLUTION=1920x1080x24

RUN apk add --no-cache \
    libprotobuf \
    tshark \
    wireshark \
    ostinato \
    ostinato-drone \
    ostinato-gui \
    xterm \
    wget \
    font-adobe-100dpi \
    mesa-dri-gallium \
    ca-certificates \
    curl \
    openssl \
    sudo \
    xvfb \
    x11vnc \
    xfce4 \
    faenza-icon-theme \
    bash

RUN addgroup gns3 && \
    adduser -h /home/gns3 -s /bin/bash -S -D -G gns3 gns3 && \
    echo "gns3:gns3" | chpasswd && \
    addgroup gns3 wireshark && \
    echo 'gns3 ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

USER gns3
WORKDIR /home/gns3

RUN mkdir -p /home/gns3/.vnc && \
	x11vnc -storepasswd gns3 /home/gns3/.vnc/passwd

COPY --chown=gns3:gns3 Ostinato.desktop /home/gns3/.config/autostart/Ostinato.desktop
COPY --chown=gns3:gns3 Ostinato.desktop /home/gns3/Desktop/Ostinato.desktop
COPY --chown=gns3:gns3 Wireshark.desktop /home/gns3/Desktop/Wireshark.desktop

RUN chmod 775 ~/Desktop/*.desktop && \
    chmod 700 ~/.vnc/passwd

USER root
COPY ostinato.png /usr/share/pixmaps/

COPY entry.sh /entry.sh
RUN chmod +x /entry.sh

CMD ["/bin/bash", "/entry.sh"]
