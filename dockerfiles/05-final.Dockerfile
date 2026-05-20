ARG IMAGE_SUFFIX=arm64
FROM dev-env:extra-tools-${IMAGE_SUFFIX}

RUN rm -rf /root/.cache/pip /root/.cache/go-build /root/go/pkg/mod /root/.npm/_cacache \
    && find /tmp /var/tmp -mindepth 1 -maxdepth 1 -exec rm -rf {} + \
    && mkdir -p /workspace /root/.cache /root/.codex /root/.config /root/.local/bin /root/.local/lib /root/.ssh /root/go /root/.npm /root/.npm-global/bin /root/.npm-global/lib /root/.cache/pip \
    && rm -f /root/.npmrc

ENV SHELL=/usr/bin/zsh
ENV WORKDIR=/workspace

WORKDIR /workspace
ENTRYPOINT ["/usr/local/bin/dev-entrypoint.sh"]
CMD ["/usr/bin/zsh"]
