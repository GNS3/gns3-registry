FROM alpine:latest

RUN apk add --no-cache --update openvswitch nano bash bash-completion

# Make bash the default shell
RUN sed -i s,/bin/ash,/bin/bash, /etc/passwd

# Enable bash completion
RUN echo -e "source /etc/profile.d/bash_completion.sh" >> ~/.bashrc

RUN mkdir /var/run/openvswitch

VOLUME /etc/openvswitch/

ADD boot.sh /bin/boot.sh

CMD /bin/bash /bin/boot.sh
