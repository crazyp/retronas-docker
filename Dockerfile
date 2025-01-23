FROM minimum2scp/systemd-bookworm:latest
RUN apt-get install -y software-properties-common \
    && apt-add-repository contrib \
    && apt-add-repository non-free \
    && apt-get update \
    && apt-get install -y coreutils util-linux dpkg sed base-passwd sudo curl passwd apt-utils build-essential iproute2 openssl iproute2-doc binutils binfmt-support nano openssh-serversha256-crypt sha512-crypt pbkdf2 argon2 scrypt bcrypt crypt md5-crypt apache htpasswd htdigest totp 2fa cowsay sshpass python3-trio python3-aioquic python-jinja2-doc python-lockfile-doc ipython3 python-netaddr-docs python-pygments-doc ttf-bitstream-vera python3-openssl python3-socks python-requests-doc python3-brotli binutils-doc cpp-doc gcc-12-locales cpp-12-doc debian-keyring g++-multilib g++-12-multilib gcc-12-doc gcc-multilib autoconf automake libtool flex bison gdb gcc-doc gcc-12-multilib glibc-doc bzr libgd-tools libstdc++-12-doc make-doc hunspell ed diffutils-doc
RUN echo "su pi" >> "/opt/init-wrapper/sbin/entrypoint.sh"
ARG USERNAME=pi
ARG USER_UID=1000
ARG USER_GID=$USER_UID
# Create the user
RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME -p raspberry \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME
# Create a volume for the home directory
VOLUME /home/pi
## Set the working directory
#WORKDIR /home/pi
# Create retronas volumes
#VOLUME opt/retronas
#VOLUME data
RUN curl -o /tmp/install_retronas.sh https://raw.githubusercontent.com/danmons/retronas/main/install_retronas.sh
RUN chmod a+x /tmp/install_retronas.sh
RUN /tmp/install_retronas.sh
# This entrypoint seems wrong as its interactive. Will likely change
# ENTRYPOINT ["/opt/retronas/retronas.sh"]
ENTRYPOINT ["/opt/init-wrapper/sbin/entrypoint.sh"]
CMD ["/sbin/init"]
#USER pi