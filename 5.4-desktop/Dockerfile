# Minimal docker container to build project
# Image: rabits/qt:5.4-desktop

FROM ubuntu:14.04
MAINTAINER Rabit <home@rabits.org> (@rabits)

ENV DEBIAN_FRONTEND noninteractive
ENV QT_PATH /opt/Qt
ENV QT_DESKTOP $QT_PATH/5.4/gcc_64
ENV PATH $QT_DESKTOP/bin:$PATH

# Install updates & requirements:
#  * git, openssh-client, ca-certificates - clone & build
#  * curl, p7zip - to download & unpack Qt bundle
#  * build-essential, pkg-config, libgl1-mesa-dev - basic Qt build requirements
#  * libsm6, libice6, libxext6, libxrender1, libfontconfig1 - dependencies of Qt bundle run-file
RUN apt-get -qq update && apt-get -qq dist-upgrade && apt-get install -qq -y --no-install-recommends \
    git \
    openssh-client \
    ca-certificates \
    curl \
    p7zip \
    build-essential \
    pkg-config \
    libgl1-mesa-dev \
    libsm6 \
    libice6 \
    libxext6 \
    libxrender1 \
    libfontconfig1 \
    && apt-get -qq clean

# Download & unpack Qt 5.4 toolchains & clean
RUN mkdir -p /tmp/qt \
    && curl -Lo /tmp/qt/installer.run 'http://download.qt.io/official_releases/qt/5.4/5.4.2/qt-opensource-linux-x64-5.4.2.run' \
    && chmod 755 /tmp/qt/installer.run && /tmp/qt/installer.run --dump-binary-data -o /tmp/qt/data \
    && mkdir $QT_PATH && cd $QT_PATH \
    && 7zr x /tmp/qt/data/qt.54.gcc_64/5.4.2-0qt5_essentials.7z > /dev/null \
    && 7zr x /tmp/qt/data/qt.54.gcc_64/5.4.2-0qt5_addons.7z > /dev/null \
    && 7zr x /tmp/qt/data/qt.54.gcc_64/5.4.2-0icu_53_1_ubuntu_11_10_64.7z > /dev/null \
    && /tmp/qt/installer.run --runoperation QtPatch linux $QT_DESKTOP qt5 \
    && rm -rf /tmp/qt

# Reconfigure locale
RUN locale-gen en_US.UTF-8 && dpkg-reconfigure locales

# Add group & user
RUN groupadd -r user && useradd --create-home --gid user user && echo 'user ALL=NOPASSWD: ALL' > /etc/sudoers.d/user

USER user
WORKDIR /home/user
ENV HOME /home/user
