ARG IMAGE_SUFFIX=arm64
FROM dev-env:20-golang-${IMAGE_SUFFIX}

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update

RUN apt-get install -y --no-install-recommends \
      libffi-dev \
      libpq-dev \
      python3 \
      python3-dev \
      python3-pip \
      python3-venv

RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/*

ENV VIRTUAL_ENV=/opt/venv
ENV PATH=/opt/venv/bin:${PATH}
ENV PIP_DISABLE_PIP_VERSION_CHECK=1
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

RUN python3 -m venv "${VIRTUAL_ENV}"
RUN "${VIRTUAL_ENV}/bin/pip" install --upgrade pip setuptools wheel
RUN "${VIRTUAL_ENV}/bin/pip" install \
      ipython \
      jupyterlab \
      uv

WORKDIR /workspace
