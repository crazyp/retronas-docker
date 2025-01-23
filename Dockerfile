FROM minimum2scp/systemd-bookworm:latest
EXPOSE 22
ARG USERNAME=pi
ARG USER_UID=1000
ARG USER_GID=$USER_UID
# Create the user
RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME -p raspberry \
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
RUN apt-get install -y apt-utils build-essential iproute2 ca-certificates krb5-locales openssl iproute2-doc binutils binfmt-support nano
RUN curl -o /tmp/install_retronas.sh https://raw.githubusercontent.com/danmons/retronas/main/install_retronas.sh
RUN chmod a+x /tmp/install_retronas.sh
RUN /tmp/install_retronas.sh
RUN echo "su - pi" >> /opt/init-wrapper/sbin/entrypoint.sh
RUN echo "root  ALL = NOPASSWD: /bin/su ALL" >> /etc/sudoers
# This entrypoint seems wrong as its interactive. Will likely change
# ENTRYPOINT ["/opt/retronas/retronas.sh"]
ENTRYPOINT ["/opt/init-wrapper/sbin/entrypoint.sh"]
#CMD ["/sbin/init"]
#USER pi