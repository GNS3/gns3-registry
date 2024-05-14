FROM alpine:latest

RUN apk add --no-cache openvswitch nano bash bash-completion

# Make bash the default shell
RUN sed -i s,/bin/ash,/bin/bash, /etc/passwd

# Enable bash completion
RUN echo -e "source /etc/bash/bash_completion.sh" >> ~/.bashrc

# Enable openvswitch bash completion
RUN echo -e "source /usr/share/bash-completion/completions/ovs-vsctl-bashcomp.bash" >> ~/.bashrc
RUN echo -e "source /usr/share/bash-completion/completions/ovs-appctl-bashcomp.bash" >> ~/.bashrc

# Configure the prompt
RUN echo -e "PS1='\h:\w\$ '" >> ~/.bashrc

VOLUME [ "/root", "/etc/openvswitch" ]

ADD init.sh /etc/openvswitch/

CMD /etc/openvswitch/init.sh; bash
