ARG IMAGE_SUFFIX=arm64
FROM dev-env:40-ml-${IMAGE_SUFFIX}

RUN "${VIRTUAL_ENV}/bin/pip" install --upgrade --force-reinstall \
      --index-url https://download.pytorch.org/whl/cu128 \
      torch torchvision torchaudio

WORKDIR /workspace
