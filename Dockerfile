FROM crazyp83/systemd-bookworm:latest
RUN apt-get update && apt-get install -y software-properties-common \
    && apt-add-repository contrib \
    && apt-add-repository non-free \
    && apt-get update \
    && apt-get install -y sudo coreutils util-linux dpkg sed base-passwd sudo curl passwd apt-utils build-essential iproute2 openssl iproute2-doc binutils binfmt-support nano openssh-server

#ENV DEBIAN_FRONTEND=noninteractive
#ARG USER=pi
#ARG UID=1000
#ARG GID=1000
#ARG TINI=v0.18.0



# Set environment variables
#ENV USER=${USER}
#ENV HOME=/home/${USER}

# Create user and setup permissions on /etc/sudoers
RUN groupadd -g 1000 pi
RUN useradd -m -s /bin/bash -N -u 1000 pi && \
    echo "pi ALL=(ALL:ALL) NOPASSWD: ALL" >> /etc/sudoers && \
    chmod 0440 /etc/sudoers && \
    chmod g+w /etc/passwd && \
    usermod -g pi pi && \
    usermod -a -G sudo pi

#ENTRYPOINT ["entrypoint.sh"]


# Copy necessary files
#COPY opt/init-wrapper/sbin/entrypoint.sh /usr/local/bin/

# Set workdir and switch back to non-root user
WORKDIR $HOME
#USER ${UID}



# Create retronas volumes
#VOLUME opt/retronas/config
#VOLUME data
RUN curl -o /tmp/install_retronas.sh https://raw.githubusercontent.com/danmons/retronas/main/install_retronas.sh
RUN chmod a+x /tmp/install_retronas.sh
RUN /tmp/install_retronas.sh

ENTRYPOINT ["/opt/init-wrapper/sbin/entrypoint.sh"]
CMD ["/sbin/init"]
#CMD ["bash"]
