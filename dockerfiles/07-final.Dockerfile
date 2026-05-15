ARG IMAGE_SUFFIX=arm64
FROM dev-env:dev-shell-${IMAGE_SUFFIX}

RUN rm -rf /root/.cache/pip /root/.cache/go-build /root/go/pkg/mod /root/.npm/_cacache \
    && find /tmp /var/tmp -mindepth 1 -maxdepth 1 -exec rm -rf {} + \
    && mkdir -p /workspace /root/.cache /root/.config /root/.local /root/go /root/.npm

ENV SHELL=/usr/bin/zsh
ENV WORKDIR=/workspace

WORKDIR /workspace
CMD ["/usr/bin/zsh"]
