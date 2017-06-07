# docker base image for basic programming tools

FROM ubuntu:xenial

RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get -y --no-install-recommends install \
    net-tools telnet traceroute openssh-client nano vim-tiny iputils-ping php php-ldap php-json \
    php-mail php-mcrypt php-mysql php-pgsql php-snmp php-sqlite3 php-ssh2 php-xmlrpc php7.0 \
    php7.0-ldap php7.0-mysql php7.0-pgsql php7.0-snmp php7.0-sqlite3 php7.0-xmlrpc \
    golang-go golang-github-go-sql-driver-mysql-dev golang-github-mattn-go-sqlite3-dev \
    golang-github-go-ldap-ldap-dev golang-github-kolo-xmlrpc-dev \
    python python3 python-pymysql python3-pymysql python-pygresql python3-postgresql \
    python-pysnmp4 python3-pysnmp4 python-ldap3 python3-ldap3 python-paramiko python3-paramiko \
    python-mailer python3-aioxmlrpc \
    perl perl-modules-5.22 libdbd-mysql-perl libdbd-sqlite3-perl libsnmp-session-perl \
    libdbd-ldap-perl libnet-ssh2-perl\ 
    && rm -rf /var/lib/apt/lists/*

VOLUME [ "/root" ]
CMD [ "sh", "-c", "cd; exec bash -i" ]

