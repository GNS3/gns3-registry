# GNS3 Web UI runtime shell for GNS3 (development and testing)
#
# Pure serving shell: nginx plus the same-origin reverse proxy to the GNS3
# controller. The image NEVER contains a Web UI build — artifacts are
# supplied at runtime through the persistent /srv/ui volume: upload a build
# as /srv/ui/<version>+<commit>/ and repoint the /srv/ui/current symlink.
#
# Designed to run as a GNS3 appliance node inside a GNS3 server project
# topology; see appliances/gns3-web-ui.gns3a in the gns3-registry repository.
#
# Build (from this directory):
#   docker build -t gns3/gns3-web-ui:latest .
FROM nginx:alpine

LABEL maintainer="YueGuobin <yueguobin@outlook.com>"
LABEL description="GNS3 Web UI for development and testing: runtime shell serving the Web UI as a GNS3 appliance node (see appliances/gns3-web-ui.gns3a), with same-origin reverse proxy to the GNS3 controller"

# Default controller address; override via environment
# (docker run -e, compose, or the appliance node environment).
ENV CONTROLLER_URL=http://host.docker.internal:3080

# openssl CLI for self-signed certificate generation
RUN apk add --no-cache openssl

COPY runtime/nginx-templates/ /etc/nginx/templates/
COPY runtime/entrypoint.d/ /docker-entrypoint.d/

# Placeholder page until a Web UI build is uploaded into the persistent
# /srv/ui volume and selected via the /srv/ui/current symlink
RUN mkdir -p /srv/ui/app \
    && echo '<html><body><p>GNS3 Web UI: no build artifact present. Upload a build to /srv/ui/&lt;version&gt;/ and repoint the /srv/ui/current symlink.</p></body></html>' \
    > /srv/ui/app/index.html \
    && ln -snf app /srv/ui/current

EXPOSE 80 443
