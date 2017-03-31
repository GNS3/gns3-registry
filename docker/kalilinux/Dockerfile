FROM kalilinux/kali-linux-docker

RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -y --no-install-recommends metasploit-framework nmap hydra sqlmap telnet openssh-client dnsutils \
    && rm -rf /var/lib/apt/lists/*

CMD /bin/bash 
