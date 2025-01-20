FROM debian:latest
RUN apt-get update && apt-get install -y curl
# Create a home directory for the user
RUN useradd -m -s /bin/bash pi
RUN echo "pi:raspberry" | chpasswd
RUN usermod -a -G sudo pi
RUN adduser pi sudo
RUN echo 'root:root' | sudo chpasswd
# Create a volume for the home directory
VOLUME /home/pi
## Set the working directory
WORKDIR /home/pi
# Create retronas volumes
VOLUME opt
VOLUME data
RUN apt-get update && \
    apt-get install -y apt-utils build-essential readline-common #readline-common-udeb readline-doc php-readline perl6-readline libterm-readline-zoid-perl libterm-readline-ttytter-perl libterm-readline-perl-perl libghc-readline-doc golang-gopkg-readline.v1-dev golang-github-wader-readline-dev golang-github-chzyer-readline-dev golang-github-bettercap-readline-dev sudo iproute2 ca-certificates krb5-locales libatm1 libbpf1 libbrotli1 libbsd0 libcap2-bin libcurl4 libelf1 libexpat1 libgpm2 libgssapi-krb5-2 libk5crypto3 libldap-2.5-0 libldap-dev libldap2-dev libldap-common libkeyutils1 libkrb5-3 libkrb5support0 libmnl0 libncursesw6 libnghttp2-14 libnsl2 libpam-cap libproc2-0 libpsl5 libreadline8 librtmp1 libsasl2-2 libsasl2-modules libsasl2-modules-db libsqlite3-0 libssh2-1 libssl3 libtirpc-common libtirpc3 libxtables12 media-types openssl procps psmisc publicsuffix readline-common iproute2-doc gpm krb5-doc krb5-user libsasl2-modules-gssapi-mit ansible-core git-man ieee-data less libcbor0.8 libcurl3-gnutls libedit2 liberror-perl libfido2-1 libgdbm-compat4 libgdbm6 libjq1 libonig5 libperl5.36 libpython3-stdlib libpython3.11-minimal libpython3.11-stdlib libx11-6 libx11-data libxau6 libxcb1 libxdmcp6 libxext6 libxmuu1 libyaml-0-2 lsb-release netbase openssh-client patch perl perl-modules-5.36 python-babel-localedata python3 python3-anyio python3-argcomplete python3-babel python3-certifi python3-cffi-backend python3-chardet python3-charset-normalizer python3-click python3-colorama python3-cryptography python3-distutils python3-dnspython python3-h11 python3-h2 python3-hpack python3-httpcore python3-httplib2 python3-httpx python3-hyperframe python3-idna python3-jinja2 python3-jmespath python3-kerberos python3-lib2to3 python3-libcloud python3-lockfile python3-markdown-it python3-markupsafe python3-mdurl python3-minimal python3-netaddr python3-ntlm-auth python3-packaging python3-passlib python3-pkg-resources python3-pygments python3-pyparsing python3-requests python3-requests-kerberos python3-requests-ntlm python3-requests-toolbelt python3-resolvelib python3-rfc3986 python3-rich python3-selinux python3-simplejson python3-six python3-sniffio python3-tz python3-urllib3 python3-winrm python3-xmltodict cowsay sshpass gettext-base git-doc git-email git-gui gitk gitweb git-cvs git-mediawiki git-svn gdbm-l10n keychain libpam-ssh-agent-auth ssh-askpass ed diffutils-doc perl-doc libterm-readline-gnu-perl libterm-readline-perl-perl make libtap-harness-archive-perl python3-doc python3-tk python3-venv python-cryptography-doc python3-cryptography-vectors python3-trio python-jinja2-doc python-lockfile-doc ipython3 python3-setuptools python-pygments-doc ttf-bitstream-vera python-pyparsing-doc python3-openssl python3-socks python-requests-doc python3-brotli python3.11-venv python3.11-doc binutils binfmt-support
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections
RUN curl -o /tmp/install_retronas.sh https://raw.githubusercontent.com/danmons/retronas/main/install_retronas.sh
RUN chmod a+x /tmp/install_retronas.sh
RUN apt -y install sudo iproute2
RUN /tmp/install_retronas.sh
#This is a entrypoint to use while working on this
ENTRYPOINT ["tail", "-f", "/dev/null"]
# This entrypoint seems wrong as its interactive. Will likely change
# ENTRYPOINT ["/opt/retronas/retronas.sh"]
USER pi