# docker base image for basic networking tools

FROM ubuntu:xenial

ENV JAVA_HOME /usr/lib/jvm/default-java

RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get -y --no-install-recommends install default-jre-headless curl \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir /odl

RUN curl https://nexus.opendaylight.org/content/repositories/opendaylight.release/org/opendaylight/integration/distribution-karaf/0.5.2-Boron-SR2/distribution-karaf-0.5.2-Boron-SR2.tar.gz > odl.tar.gz && tar -xvzf odl.tar.gz --strip-components=1 -C /odl && rm odl.tar.gz

# Start karaf and retry 20 times to send the command
RUN /odl/bin/start && /odl/bin/client -r 20 feature:install odl-restconf
RUN /odl/bin/start && /odl/bin/client -r 20 feature:install odl-l2switch-switch
RUN /odl/bin/start && /odl/bin/client -r 20 feature:install odl-mdsal-apidocs
RUN /odl/bin/start && /odl/bin/client -r 20 feature:install odl-dlux-all

#ADD config.ini /odl/configuration

#VOLUME /odl/configuration/current

CMD /odl/bin/karaf 
