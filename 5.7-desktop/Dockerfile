# Minimal docker container to build project
# Image: rabits/qt:5.7-desktop

FROM ubuntu:16.04
MAINTAINER Rabit <home@rabits.org> (@rabits)

ENV DEBIAN_FRONTEND noninteractive
ENV QT_PATH /opt/Qt
ENV QT_DESKTOP $QT_PATH/5.7/gcc_64
ENV PATH $QT_DESKTOP/bin:$PATH

# Install updates & requirements:
#  * git, openssh-client, ca-certificates - clone & build
#  * locales, sudo - useful to set utf-8 locale & sudo usage
#  * curl - to download Qt bundle
#  * build-essential, pkg-config, libgl1-mesa-dev - basic Qt build requirements
#  * libsm6, libice6, libxext6, libxrender1, libfontconfig1, libdbus-1-3 - dependencies of the Qt bundle run-file
RUN apt-get -qq update && apt-get -qq dist-upgrade && apt-get install -qq -y --no-install-recommends \
    git \
    openssh-client \
    ca-certificates \
    locales \
    sudo \
    curl \
    build-essential \
    pkg-config \
    libgl1-mesa-dev \
    libsm6 \
    libice6 \
    libxext6 \
    libxrender1 \
    libfontconfig1 \
    libdbus-1-3 \
    && apt-get -qq clean

COPY extract-qt-installer.sh /tmp/qt/

# Download & unpack Qt 5.7 toolchains & clean
RUN curl -Lo /tmp/qt/installer.run 'http://download.qt.io/official_releases/qt/5.7/5.7.1/qt-opensource-linux-x64-5.7.1.run' \
    && QT_CI_PACKAGES=qt.57.gcc_64 /tmp/qt/extract-qt-installer.sh /tmp/qt/installer.run "$QT_PATH" \
    && find "$QT_PATH" -mindepth 1 -maxdepth 1 ! -name '5.*' -exec echo 'Cleaning Qt SDK: {}' \; -exec rm -r '{}' \; \
    && rm -rf /tmp/qt

# Reconfigure locale
RUN locale-gen en_US.UTF-8 && dpkg-reconfigure locales

# Add group & user + sudo
RUN groupadd -r user && useradd --create-home --gid user user && echo 'user ALL=NOPASSWD: ALL' > /etc/sudoers.d/user

USER user
WORKDIR /home/user
ENV HOME /home/user
