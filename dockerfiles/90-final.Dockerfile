ARG IMAGE_SUFFIX=arm64
FROM dev-env:50-extra-tools-${IMAGE_SUFFIX}

RUN mkdir -p /workspace /root/.cache /root/.config /root/.local /root/go /root/.npm

ENV SHELL=/usr/bin/zsh
ENV WORKDIR=/workspace

WORKDIR /workspace
CMD ["/usr/bin/zsh"]
