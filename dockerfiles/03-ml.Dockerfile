ARG IMAGE_SUFFIX=arm64
FROM dev-env:python-${IMAGE_SUFFIX}

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
      libblas-dev \
      liblapack-dev \
    && apt-get clean \
    && find /var/lib/apt/lists -mindepth 1 -maxdepth 1 -exec rm -rf {} + \
    && find /tmp /var/tmp -mindepth 1 -maxdepth 1 -exec rm -rf {} +

RUN "${VIRTUAL_ENV}/bin/pip" install \
      matplotlib \
      numpy \
      pandas \
      pillow \
      scikit-learn \
      scipy \
      seaborn \
      tqdm \
    && rm -rf /root/.cache/pip \
    && find "${VIRTUAL_ENV}" -type d -name __pycache__ -prune -exec rm -rf {} + \
    && find "${VIRTUAL_ENV}" -type f -name '*.pyc' -delete \
    && find /tmp /var/tmp -mindepth 1 -maxdepth 1 -exec rm -rf {} +

WORKDIR /workspace
