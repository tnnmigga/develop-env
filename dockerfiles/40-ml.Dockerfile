ARG IMAGE_SUFFIX=arm64
FROM dev-env:30-python-${IMAGE_SUFFIX}

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update

RUN apt-get install -y --no-install-recommends \
      libblas-dev \
      liblapack-dev

RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/*

RUN "${VIRTUAL_ENV}/bin/pip" install \
      matplotlib \
      numpy \
      pandas \
      pillow \
      scikit-learn \
      scipy \
      seaborn \
      tqdm

WORKDIR /workspace
