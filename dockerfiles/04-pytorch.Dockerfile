ARG IMAGE_SUFFIX=arm64
FROM dev-env:ml-${IMAGE_SUFFIX}

ARG PYTORCH_FLAVOR=cpu

RUN if [ "${PYTORCH_FLAVOR}" = "cuda" ]; then \
      "${VIRTUAL_ENV}/bin/pip" install --upgrade \
        --index-url https://download.pytorch.org/whl/cu128 \
        torch torchvision torchaudio; \
    else \
      "${VIRTUAL_ENV}/bin/pip" install --upgrade \
        --index-url https://download.pytorch.org/whl/cpu \
        "torch==2.7.1+cpu" \
        "torchvision==0.22.1" \
        "torchaudio==2.7.1"; \
    fi \
    && rm -rf /root/.cache/pip \
    && find "${VIRTUAL_ENV}" -type d -name __pycache__ -prune -exec rm -rf {} + \
    && find "${VIRTUAL_ENV}" -type f -name '*.pyc' -delete \
    && find /tmp /var/tmp -mindepth 1 -maxdepth 1 -exec rm -rf {} +

WORKDIR /workspace
