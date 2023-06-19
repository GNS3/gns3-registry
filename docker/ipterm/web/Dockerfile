# docker image with firefox web browser and basic networking tools

ARG DOCKER_REPOSITORY
FROM $DOCKER_REPOSITORY/ipterm-base

RUN set -e -x \
#
# install web tools
#
    && export DEBIAN_FRONTEND=noninteractive \
    && apt-get update \
    && apt-get -y --no-install-recommends install \
        firefox-esr lxterminal jwm menu xfe wmctrl \
    && rm -rf /var/lib/apt/lists/* \
#
# update firefox preferences
#
    && printf '\n\
// Disable welcome page on first start and when showing about:home\n\
pref("browser.startup.homepage_override.mstone","ignore");\n\
pref("trailhead.firstrun.branches", "nofirstrun-empty");\n' \
	>> /etc/firefox-esr/firefox-esr.js \
#
# customize jwm menu
#
    && printf '\
?package(firefox-esr):\\\n\
 needs="x11"\\\n\
 section="Applications"\\\n\
 title="Mozilla Firefox"\\\n\
 command="firefox"\n' \
        > /etc/menu/firefox \
    && printf '\
?package(xfe):\\\n\
 needs="x11"\\\n\
 section="/"\\\n\
 title="File Manager"\\\n\
 command="xfe"\n' \
        > /etc/menu/xfe \
    && printf '\
?package(xfe):\\\n\
 needs="x11"\\\n\
 section="Applications/TextEditor"\\\n\
 title="X File Write"\\\n\
 command="xfwrite"\n' \
        > /etc/menu/xfwrite \
    && echo "postrun=\"sed -i '/^    </ d' debian-menu\"" >> /etc/menu-methods/jwm \
    && sed -i 's/\(Desktops width\)="[0-9]*"/\1="2"/' /etc/jwm/system.jwmrc \
    && sed -i '/<Font>/ s/-[0-9]\+/-10/' /etc/jwm/system.jwmrc \
    && sed -i 's/xterm/x-terminal-emulator/g' /etc/jwm/system.jwmrc \
    && update-menus \
#
# set lxterminal defaults
#
    && mkdir -p /root/.config/lxterminal \
    && printf '\
[general]\n\
scrollback=1000\n\
fgcolor=#ffffff\n' \
        > /root/.config/lxterminal/lxterminal.conf \
#
# set xfe defaults
#
    && mkdir -p /root/.config/xfe \
    && printf '\
[OPTIONS]\n\
root_warn=0\n\
\n\
[PROGS]\n\
xterm=x-terminal-emulator\n' \
        > /root/.config/xfe/xferc \
#
# startup script
#
    && printf '\
\043!/bin/sh\n\
[ $$ -eq 1 ] && exec dumb-init -- "$0" "$@"\n\
\n\
cd\n\
export SHELL=/bin/bash\n\
\n\
\043 start firefox\n\
firefox &\n\
\n\
\043 start a windows manager if none is active\n\
if wmctrl -m > /dev/null 2>&1; then\n\
	wait $!\n\
else\n\
	jwm\n\
fi\n' \
        > /etc/init.sh && chmod +x /etc/init.sh

VOLUME [ "/root" ]
CMD [ "/etc/init.sh" ]
