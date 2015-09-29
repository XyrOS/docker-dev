# VERSION 1.0
# AUTHOR:         Nicolas Lamirault <nicolas.lamirault@gmail.com>
# DESCRIPTION:    xyros/aosp

FROM ubuntu:15.04

MAINTAINER Nicolas Lamirault <nicolas.lamirault@gmail.com>

# Dependencies
RUN apt-get purge openjdk-\* icedtea-\* icedtea6-\*
RUN apt-get update && \
    apt-get install -y bison g++-multilib git gperf curl \
    libxml2-utils make python-networkx zlib1g-dev zip && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install Repo tool
RUN curl https://storage.googleapis.com/git-repo-downloads/repo > /usr/local/bin/repo && \
	chmod 755 /usr/local/bin/*

# All builds will be done by user aosp
RUN useradd --create-home aosp
ADD gitconfig /home/aosp/.gitconfig
ADD ssh_config /home/aosp/.ssh/config
RUN chown aosp:aosp /home/aosp/.gitconfig

# The persistent data will be in these two directories, everything else is
# considered to be ephemeral
VOLUME ["/tmp/ccache", "/aosp"]

# Improve rebuild performance by enabling compiler cache
ENV USE_CCACHE 1
ENV CCACHE_DIR /tmp/ccache

# Work in the build directory, repo is expected to be init'd here
USER aosp
WORKDIR /aosp
