FROM alpine:latest

RUN apk add --no-cache openvswitch nano bash bash-completion

# Make bash the default shell
RUN sed -i s,/bin/ash,/bin/bash, /etc/passwd

# Enable bash completion
RUN echo -e "source /etc/profile.d/bash_completion.sh" >> ~/.bashrc

# Enable openvswitch bash completion
RUN echo -e "source /usr/share/bash-completion/completions/ovs-vsctl-bashcomp.bash" >> ~/.bashrc
RUN echo -e "source /usr/share/bash-completion/completions/ovs-appctl-bashcomp.bash" >> ~/.bashrc

# Configure the prompt
RUN echo -e "PS1='\h:\w\$ '" >> ~/.bashrc

RUN mkdir /var/run/openvswitch

VOLUME /etc/openvswitch/

ADD boot.sh /bin/boot.sh

CMD /bin/bash /bin/boot.sh
