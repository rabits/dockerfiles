# Minimal docker container to build project
# Image: rabits/qt:5.7-android

FROM ubuntu:16.04
MAINTAINER Rabit <home@rabits.org> (@rabits)

ENV DEBIAN_FRONTEND noninteractive
ENV QT_PATH /opt/Qt
ENV QT_ANDROID ${QT_PATH}/5.7/android_armv7
ENV ANDROID_HOME /opt/android-sdk-linux
ENV ANDROID_SDK_ROOT ${ANDROID_HOME}
ENV ANDROID_NDK_ROOT /opt/android-ndk
ENV ANDROID_NDK_TOOLCHAIN_PREFIX arm-linux-androideabi
ENV ANDROID_NDK_TOOLCHAIN_VERSION 4.9
ENV ANDROID_NDK_HOST linux-x86_64
ENV ANDROID_NDK_PLATFORM android-21
ENV ANDROID_NDK_TOOLS_PREFIX ${ANDROID_NDK_TOOLCHAIN_PREFIX}
ENV QMAKESPEC android-g++
ENV PATH ${PATH}:${QT_ANDROID}/bin:${PATH}:${ANDROID_HOME}/tools:${ANDROID_HOME}/platform-tools

# Install updates & requirements:
#  * git, openssh-client, ca-certificates - clone & build
#  * locales, sudo - useful to set utf-8 locale & sudo usage
#  * curl - to download Qt bundle
#  * make, default-jdk, ant - basic build requirements
#  * libsm6, libice6, libxext6, libxrender1, libfontconfig1, libdbus-1-3 - dependencies of Qt bundle run-file
#  * libc6:i386, libncurses5:i386, libstdc++6:i386, libz1:i386 - dependencides of android sdk binaries
RUN dpkg --add-architecture i386 && apt-get -qq update && apt-get -qq dist-upgrade && apt-get install -qq -y --no-install-recommends \
    git \
    openssh-client \
    ca-certificates \
    locales \
    sudo \
    curl \
    make \
    default-jdk \
    ant \
    libsm6 \
    libice6 \
    libxext6 \
    libxrender1 \
    libfontconfig1 \
    libdbus-1-3 \
    libc6:i386 \
    libncurses5:i386 \
    libstdc++6:i386 \
    libz1:i386 \
    && apt-get -qq clean

COPY extract-qt-installer.sh /tmp/qt/

# Download & unpack Qt 5.7 toolchains & clean
RUN curl -Lo /tmp/qt/installer.run 'http://download.qt.io/official_releases/qt/5.7/5.7.1/qt-opensource-linux-x64-android-5.7.1.run' \
    && QT_CI_PACKAGES=qt.57.android_armv7 /tmp/qt/extract-qt-installer.sh /tmp/qt/installer.run "$QT_PATH" \
    && find "$QT_PATH" -mindepth 1 -maxdepth 1 ! -name '5.*' -exec echo 'Cleaning Qt SDK: {}' \; -exec rm -r '{}' \; \
    && rm -rf /tmp/qt

# Download & unpack android SDK
RUN mkdir /tmp/android && curl -Lo /tmp/android/sdk.tgz 'http://dl.google.com/android/android-sdk_r24.4.1-linux.tgz' \
    && tar --no-same-owner -xf /tmp/android/sdk.tgz -C /opt \
    && rm -rf /tmp/android && echo "y" | android update sdk -u -a -t tools,platform-tools,build-tools-21.1.2,$ANDROID_NDK_PLATFORM

# Download & unpack android NDK
RUN mkdir /tmp/android && cd /tmp/android && curl -Lo ndk.bin 'http://dl.google.com/android/ndk/android-ndk-r10e-linux-x86_64.bin' \
    && chmod +x ndk.bin && ./ndk.bin > /dev/null && mv android-ndk-r10e $ANDROID_NDK_ROOT && chmod -R +rX $ANDROID_NDK_ROOT \
    && rm -rf /tmp/android

# Reconfigure locale
RUN locale-gen en_US.UTF-8 && dpkg-reconfigure locales

# Add group & user
RUN groupadd -r user && useradd --create-home --gid user user && echo 'user ALL=NOPASSWD: ALL' > /etc/sudoers.d/user

USER user
WORKDIR /home/user
ENV HOME /home/user
