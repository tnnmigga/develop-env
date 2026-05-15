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

ENV VIRTUAL_ENV=/opt/venv
ENV PATH=/opt/venv/bin:${PATH}
ENV PIP_DISABLE_PIP_VERSION_CHECK=1
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

RUN python3 -m venv "${VIRTUAL_ENV}" \
    && "${VIRTUAL_ENV}/bin/pip" install --upgrade pip setuptools wheel \
    && "${VIRTUAL_ENV}/bin/pip" install \
      ipython \
      uv \
    && rm -rf /root/.cache/pip \
    && find "${VIRTUAL_ENV}" -type d -name __pycache__ -prune -exec rm -rf {} + \
    && find "${VIRTUAL_ENV}" -type f -name '*.pyc' -delete \
    && find /tmp /var/tmp -mindepth 1 -maxdepth 1 -exec rm -rf {} +

WORKDIR /workspace
