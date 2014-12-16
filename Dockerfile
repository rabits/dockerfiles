# Minimal docker container for common build
# Image: rabits/build-minimal:ubuntu-14.04

FROM ubuntu:14.04
MAINTAINER Rabit <home@rabits.org> (@rabits)

ENV DEBIAN_FRONTEND noninteractive

# Install updates & requirements:
RUN apt-get -qq update && apt-get -qq dist-upgrade && apt-get install -qq -y --no-install-recommends \
    git \
    openssh-client \
    ca-certificates \
    curl \
    && apt-get -qq clean

# Reconfigure locale and add group, user & sudo
RUN locale-gen en_US.UTF-8 && dpkg-reconfigure locales \
    && groupadd -r user && useradd --create-home --gid user user && echo 'user ALL=NOPASSWD: ALL' > /etc/sudoers.d/user

USER user
WORKDIR /home/user
