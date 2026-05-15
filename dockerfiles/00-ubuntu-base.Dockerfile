FROM ubuntu:24.04

ARG DEBIAN_FRONTEND=noninteractive
ARG TARGET_ARCH=arm64

ENV TZ=Asia/Shanghai
ENV TARGET_ARCH=${TARGET_ARCH}

RUN apt-get update

RUN apt-get install -y --no-install-recommends \
      ca-certificates \
      curl \
      gnupg \
      locales \
      tzdata \
      wget

RUN ln -snf "/usr/share/zoneinfo/${TZ}" /etc/localtime
RUN echo "${TZ}" > /etc/timezone
RUN sed -i 's/^# *\(en_US.UTF-8 UTF-8\)/\1/' /etc/locale.gen
RUN locale-gen

RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/*

ENV LANG=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8

WORKDIR /workspace
