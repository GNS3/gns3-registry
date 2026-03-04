FROM alpine:3.22

LABEL maintainer="developers@gns3.net"

# --- Install base packages ---
RUN apk add --no-cache \
    openvswitch \
    nano \
    bash \
    bash-completion

# Make bash the default shell
RUN sed -i 's|/bin/ash|/bin/bash|' /etc/passwd

# Configure bash completion
RUN echo "" >> /root/.bashrc && \
    echo "source /etc/bash/bash_completion.sh" >> /root/.bashrc && \
    echo "source /usr/share/bash-completion/completions/ovs-vsctl-bashcomp.bash" >> /root/.bashrc && \
    echo "source /usr/share/bash-completion/completions/ovs-appctl-bashcomp.bash" >> /root/.bashrc && \
    echo "PS1='\\h:\\w\\$ '" >> /root/.bashrc


VOLUME ["/root", "/etc/openvswitch"]

COPY init.sh /etc/openvswitch/init.sh
RUN chmod +x /etc/openvswitch/init.sh

CMD ["/bin/bash", "-c", "/etc/openvswitch/init.sh && exec bash"]
