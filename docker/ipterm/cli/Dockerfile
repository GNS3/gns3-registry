# docker image with basic networking tools

ARG DOCKER_REPOSITORY
FROM $DOCKER_REPOSITORY/ipterm-base

#
# startup script
#
RUN printf '\
\043!/bin/sh\n\
[ $$ -eq 1 ] && exec dumb-init -- "$0" "$@"\n\
\n\
[ -f /root/init.sh ] && [ -x /root/init.sh ] && /root/init.sh\n\
\n\
cd\n\
if [ $# -gt 0 ]; then\n\
	"$@"\n\
else\n\
	bash -i -l\n\
fi\n' \
        > /etc/init.sh && chmod +x /etc/init.sh

ENTRYPOINT [ "/etc/init.sh" ]
VOLUME [ "/root" ]
