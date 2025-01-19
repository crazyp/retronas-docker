FROM debian:latest
RUN apt-get update
RUN apt-get full-upgrade
RUN apt-get upgrade
RUN apt-get install -y readline-common #readline-common-udeb readline-doc php-readline perl6-readline libterm-readline-zoid-perl libterm-readline-ttytter-perl libterm-readline-perl-perl libghc-readline-doc golang-gopkg-readline.v1-dev golang-github-wader-readline-dev golang-github-chzyer-readline-dev golang-github-bettercap-readline-dev
RUN apt-get install -y sudo curl iproute2 apt-utils ca-certificates krb5-locales libatm1 libbpf1 libbrotli1 libbsd0 libcap2-bin libcurl4 libelf1 libexpat1 libgpm2 libgssapi-krb5-2 libk5crypto3 libldap-2.5-0 libldap-dev libldap2-dev libldap-common libkeyutils1 libkrb5-3 libkrb5support0 libmnl0 libncursesw6 libnghttp2-14 libnsl2 libpam-cap libproc2-0 libpsl5 libreadline8 librtmp1 libsasl2-2 libsasl2-modules libsasl2-modules-db libsqlite3-0 libssh2-1 libssl3 libtirpc-common libtirpc3 libxtables12 media-types openssl procps psmisc publicsuffix readline-common iproute2-doc gpm krb5-doc krb5-user libsasl2-modules-gssapi-mit
RUN curl -o /tmp/install_retronas.sh https://raw.githubusercontent.com/danmons/retronas/main/install_retronas.sh
RUN chmod a+x /tmp/install_retronas.sh
RUN /tmp/install_retronas.sh
#This is a entrypoint to use while working on this
ENTRYPOINT ["tail", "-f", "/dev/null"]
# This entrypoint seems wrong as its interactive. Will likely change
# ENTRYPOINT ["/opt/retronas/retronas.sh"]