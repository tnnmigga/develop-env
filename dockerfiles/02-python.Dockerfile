ARG IMAGE_SUFFIX=arm64
FROM dev-env:golang-${IMAGE_SUFFIX}

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
      libffi-dev \
      libpq-dev \
    && apt-get clean \
    && find /var/lib/apt/lists -mindepth 1 -maxdepth 1 -exec rm -rf {} + \
    && find /tmp /var/tmp -mindepth 1 -maxdepth 1 -exec rm -rf {} +

# Install Miniconda
RUN curl -fsSL "https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-$(uname -m).sh" -o /tmp/miniconda.sh \
    && bash /tmp/miniconda.sh -b -p /opt/conda \
    && rm /tmp/miniconda.sh \
    && /opt/conda/bin/conda clean -afy \
    && find /tmp /var/tmp -mindepth 1 -maxdepth 1 -exec rm -rf {} +

ENV PATH=/opt/conda/bin:${PATH}
ENV PIP_DISABLE_PIP_VERSION_CHECK=1

WORKDIR /workspace
