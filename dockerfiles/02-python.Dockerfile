ARG IMAGE_SUFFIX=arm64
FROM dev-env:golang-${IMAGE_SUFFIX}

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
      libffi-dev \
      libpq-dev \
      python3 \
      python3-dev \
      python3-pip \
      python3-venv \
    && apt-get clean \
    && find /var/lib/apt/lists -mindepth 1 -maxdepth 1 -exec rm -rf {} + \
    && find /tmp /var/tmp -mindepth 1 -maxdepth 1 -exec rm -rf {} +

ENV PIP_DISABLE_PIP_VERSION_CHECK=1

WORKDIR /workspace
