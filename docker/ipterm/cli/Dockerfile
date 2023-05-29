# docker image with basic networking tools

FROM gns3/ipterm-base

# add a dummy layer to get an updated container timestamp
RUN /bin/true

VOLUME [ "/root" ]
CMD [ "sh", "-c", "cd; exec bash -i" ]
