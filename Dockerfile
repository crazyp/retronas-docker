FROM debian:latest
ARG USERNAME=pi
ARG USER_UID=1000
ARG USER_GID=$USER_UID
RUN printf '#!/bin/sh\nexit 0' > /usr/sbin/policy-rc.d
# Create the user
RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME -p raspberry\
    #
    # [Optional] Add sudo support. Omit if you don't need to install software after connecting.
    && apt-get update \
    && apt-get install -y sudo curl passwd \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME
# Create a volume for the home directory
VOLUME /home/pi
## Set the working directory
WORKDIR /home/pi
# Create retronas volumes
#VOLUME opt/retronas
#VOLUME data
RUN apt-get install -y systemd systemd-sysv dbus dbus-user-session
RUN apt update
RUN apt install apt-utils build-essential sudo iproute2 ca-certificates krb5-locales openssl iproute2-doc binutils binfmt-support
#RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections
RUN printf "systemctl start systemd-logind" >> /etc/profile
RUN curl -o /tmp/install_retronas.sh https://raw.githubusercontent.com/danmons/retronas/main/install_retronas.sh
RUN chmod a+x /tmp/install_retronas.sh
RUN /tmp/install_retronas.sh
#This is a entrypoint to use while working on this
ENTRYPOINT ["tail", "-f", "/dev/null"]
# This entrypoint seems wrong as its interactive. Will likely change
# ENTRYPOINT ["/opt/retronas/retronas.sh"]
#ENTRYPOINT ["/sbin/init"]
USER pi