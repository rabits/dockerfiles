# Minimal docker container to build project
# Image: rabits/qt:5.4-android

FROM ubuntu:14.04
MAINTAINER Rabit <home@rabits.org> (@rabits)

ENV DEBIAN_FRONTEND noninteractive
ENV QT_PATH /opt/Qt
ENV QT_ANDROID ${QT_PATH}/5.4/android_armv7
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
#  * curl, p7zip - to download & unpack Qt bundle
#  * make, default-jdk, ant - basic build requirements
#  * libsm6, libice6, libxext6, libxrender1, libfontconfig1 - dependencies of Qt bundle run-file
#  * libc6:i386, libncurses5:i386, libstdc++6:i386, libz1:i386 - dependencides of android sdk binaries
RUN sudo dpkg --add-architecture i386 && apt-get -qq update && apt-get -qq dist-upgrade && apt-get install -qq -y --no-install-recommends \
    git \
    openssh-client \
    ca-certificates \
    make \
    default-jdk \
    ant \
    curl \
    p7zip \
    libsm6 \
    libice6 \
    libxext6 \
    libxrender1 \
    libfontconfig1 \
    libc6:i386 \
    libncurses5:i386 \
    libstdc++6:i386 \
    libz1:i386 \
    && apt-get -qq clean

# Download & unpack Qt 5.4 toolchains & clean
RUN mkdir -p /tmp/qt \
    && curl -Lo /tmp/qt/installer.run 'http://download.qt.io/official_releases/qt/5.4/5.4.2/qt-opensource-linux-x64-android-5.4.2.run' \
    && chmod +x /tmp/qt/installer.run && /tmp/qt/installer.run --dump-binary-data -o /tmp/qt/data \
    && mkdir $QT_PATH && cd $QT_PATH \
    && 7zr x /tmp/qt/data/qt.54.android_armv7/5.4.2-0qt5_essentials.7z > /dev/null \
    && 7zr x /tmp/qt/data/qt.54.android_armv7/5.4.2-0qt5_addons.7z > /dev/null \
    && /tmp/qt/installer.run --runoperation QtPatch linux $QT_ANDROID qt5 \
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
