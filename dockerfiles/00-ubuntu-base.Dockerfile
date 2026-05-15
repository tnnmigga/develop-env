FROM ubuntu:24.04

ARG DEBIAN_FRONTEND=noninteractive
ARG TARGET_ARCH=arm64

ENV TZ=Asia/Shanghai
ENV TARGET_ARCH=${TARGET_ARCH}

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
      build-essential \
      ca-certificates \
      curl \
      git \
      iputils-ping \
      less \
      locales \
      net-tools \
      openssh-client \
      pkg-config \
      procps \
      tzdata \
      unzip \
      wget \
      xz-utils \
      zip \
      zsh \
    && apt-get clean \
    && find /var/lib/apt/lists -mindepth 1 -maxdepth 1 -exec rm -rf {} + \
    && find /tmp /var/tmp -mindepth 1 -maxdepth 1 -exec rm -rf {} +

RUN ln -snf "/usr/share/zoneinfo/${TZ}" /etc/localtime
RUN echo "${TZ}" > /etc/timezone
RUN sed -i 's/^# *\(en_US.UTF-8 UTF-8\)/\1/' /etc/locale.gen
RUN locale-gen

ENV LANG=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8

WORKDIR /workspace
