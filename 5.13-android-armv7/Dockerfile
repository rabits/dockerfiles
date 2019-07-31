# Minimal docker container to build project
# Image: rabits/qt:5.13-android-armv7

FROM ubuntu:18.04
MAINTAINER Rabit <home@rabits.org> (@rabits)

ARG QT_VERSION=5.13.0
ARG QT_URL="https://download.qt.io/official_releases/qt/__QT_MAJMIN__/${QT_VERSION}/qt-opensource-linux-x64-${QT_VERSION}.run"
ARG QT_SHA256="0cd82c80287a783bd5db1339b6184803d57517c9450ffe16f505254853f0a41f"

ARG NDK_TOOLCHAIN_PREFIX=arm-linux-androideabi
ARG NDK_VERSION=r20
ARG NDK_URL="https://dl.google.com/android/repository/android-ndk-${NDK_VERSION}-linux-x86_64.zip"
ARG NDK_SHA256="57435158f109162f41f2f43d5563d2164e4d5d0364783a9a6fab3ef12cb06ce0"

ARG SDK_URL="https://dl.google.com/android/repository/sdk-tools-linux-3859397.zip"
ARG SDK_SHA256="444e22ce8ca0f67353bda4b85175ed3731cae3ffa695ca18119cbacef1c1bea0"
ARG SDK_PLATFORM=android-29
ARG SDK_INSTALL_DIR=/opt/android-sdk
ARG SDK_BUILD_TOOLS=29.0.1
ARG SDK_PACKAGES="tools platform-tools"

ENV DEBIAN_FRONTEND=noninteractive \
    QT_PATH=/opt/Qt \
    QT_BIN_PACKAGE=android_armv7
ENV QT_ANDROID=${QT_PATH}/${QT_VERSION}/${QT_BIN_PACKAGE} \
    ANDROID_HOME=${SDK_INSTALL_DIR} \
    ANDROID_SDK_ROOT=${SDK_INSTALL_DIR} \
    ANDROID_SDK_BUILD_TOOLS=${SDK_BUILD_TOOLS} \
    ANDROID_NDK_ROOT=/opt/android-ndk \
    ANDROID_NDK_TOOLS_PREFIX=${NDK_TOOLCHAIN_PREFIX} \
    ANDROID_NDK_TOOLCHAIN_PREFIX=${NDK_TOOLCHAIN_PREFIX} \
    ANDROID_NDK_TOOLCHAIN_VERSION=4.9 \
    ANDROID_NDK_TOOLCHAIN_ABI=armeabi-v7a \
    ANDROID_NDK_HOST=linux-x86_64 \
    ANDROID_NDK_PLATFORM=${SDK_PLATFORM} \
    QMAKESPEC=android-g++
ENV PATH ${QT_ANDROID}/bin:${ANDROID_HOME}/tools:${ANDROID_HOME}/tools/bin:${ANDROID_HOME}/platform-tools:${PATH}

# Install updates & requirements:
#  * unzip - unpack platform tools
#  * git, openssh-client, ca-certificates - clone & build
#  * locales, sudo - useful to set utf-8 locale & sudo usage
#  * curl - to download Qt bundle
#  * cmake, ninja-build - build system
#  * make, openjdk-8-jdk-headless, ant - basic build requirements
#  * libsm6, libice6, libxext6, libxrender1, libfontconfig1, libdbus-1-3, libx11-xcb1 - dependencies of Qt bundle run-file
#  * libc6:i386, libncurses5:i386, libstdc++6:i386, libz1:i386 - dependencides of android sdk binaries
RUN dpkg --add-architecture i386 && apt update && apt full-upgrade -y && apt install -y --no-install-recommends \
    unzip \
    git \
    openssh-client \
    ca-certificates \
    locales \
    sudo \
    curl \
    cmake \
    ninja-build \
    make \
    openjdk-8-jdk-headless \
    openjdk-8-jre-headless \
    ant \
    libsm6 \
    libice6 \
    libxext6 \
    libxrender1 \
    libfontconfig1 \
    libdbus-1-3 \
    libx11-xcb1 \
    libc6:i386 \
    libncurses5:i386 \
    libstdc++6:i386 \
    libz1:i386 \
    && apt-get -qq clean \
    && rm -rf /var/lib/apt/lists/*

COPY extract-qt-installer.sh /tmp/qt/

# Download & unpack Qt toolchains & clean
RUN echo "${QT_SHA256} -" > sum.txt && curl -fLs "$(echo "${QT_URL}" | sed "s/__QT_MAJMIN__/$(echo "${QT_VERSION}" | cut -d. -f 1-2)/g")" | tee /tmp/qt/installer.run | sha256sum -c sum.txt \
    && QT_CI_PACKAGES=qt.qt5.$(echo "${QT_VERSION}" | tr -d .).${QT_BIN_PACKAGE} /tmp/qt/extract-qt-installer.sh /tmp/qt/installer.run "$QT_PATH" \
    && find "${QT_PATH}" -mindepth 1 -maxdepth 1 ! -name "${QT_VERSION}" -exec echo 'Cleaning Qt SDK: {}' \; -exec rm -r '{}' \; \
    && rm -rf /tmp/qt

# Download & unpack android SDK
RUN echo "${SDK_SHA256} -" > sum.txt && curl -fLs "${SDK_URL}" | tee /tmp/sdk-tools.zip | sha256sum -c sum.txt \
    && mkdir -p /opt/android-sdk && unzip -q /tmp/sdk-tools.zip -d /opt/android-sdk && rm -f /tmp/sdk-tools.zip \
    && yes | sdkmanager --licenses && sdkmanager --update && sdkmanager --verbose "platforms;${SDK_PLATFORM}" "build-tools;${SDK_BUILD_TOOLS}" ${SDK_PACKAGES}

# Download & unpack android NDK
RUN mkdir /tmp/android && cd /tmp/android && echo "${NDK_SHA256} -" > sum.txt && curl -fLs "${NDK_URL}" | tee ndk.zip | sha256sum -c sum.txt \
    && unzip -q ndk.zip && mv android-ndk-* $ANDROID_NDK_ROOT && chmod -R +rX $ANDROID_NDK_ROOT \
    && rm -rf /tmp/android

# Reconfigure locale
RUN locale-gen en_US.UTF-8 && dpkg-reconfigure locales

# Add group & user
RUN groupadd -r user && useradd --create-home --gid user user && echo 'user ALL=NOPASSWD: ALL' > /etc/sudoers.d/user

USER user
WORKDIR /home/user
ENV HOME /home/user
