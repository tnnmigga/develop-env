ARG IMAGE_SUFFIX=arm64
FROM dev-env:pytorch-${IMAGE_SUFFIX}

ARG DEBIAN_FRONTEND=noninteractive

ENV NVM_DIR=/root/.nvm
ENV PATH=/opt/node-current/bin:${PATH}

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
      htop \
      openssh-server \
      protobuf-compiler \
      vim \
    && apt-get clean \
    && find /var/lib/apt/lists -mindepth 1 -maxdepth 1 -exec rm -rf {} + \
    && find /tmp /var/tmp -mindepth 1 -maxdepth 1 -exec rm -rf {} +

RUN mkdir -p /run/sshd /etc/ssh/authorized_keys \
    && chmod 0755 /run/sshd /etc/ssh/authorized_keys \
    && printf '%s\n' \
      'PermitRootLogin prohibit-password' \
      'PasswordAuthentication no' \
      'KbdInteractiveAuthentication no' \
      'PubkeyAuthentication yes' \
      'AuthorizedKeysFile /etc/ssh/authorized_keys/%u' \
      > /etc/ssh/sshd_config.d/dev-env.conf

COPY config/dev-entrypoint.sh /usr/local/bin/dev-entrypoint.sh
COPY config/vimrc /root/.vimrc
RUN chmod 0755 /usr/local/bin/dev-entrypoint.sh
RUN sed -i 's/\r$//' /root/.vimrc

RUN git clone --depth=1 https://github.com/nvm-sh/nvm.git "${NVM_DIR}" \
    && . "${NVM_DIR}/nvm.sh" \
    && nvm install node \
    && nvm alias default node \
    && nvm use default \
    && node_bin="$(nvm which default)" \
    && node_home="$(dirname "$(dirname "${node_bin}")")" \
    && ln -sfn "${node_home}" /opt/node-current \
    && node --version \
    && npm --version \
    && rm -rf "${NVM_DIR}/.git" "${NVM_DIR}/.cache" \
    && find /tmp /var/tmp -mindepth 1 -maxdepth 1 -exec rm -rf {} +

RUN . "${NVM_DIR}/nvm.sh" \
    && nvm use default \
    && npm install -g \
      @anthropic-ai/claude-code \
      typescript \
      ts-node \
      pnpm \
      yarn \
      yddict \
    && npm cache clean --force \
    && rm -rf /root/.npm/_cacache /root/.npm/_logs \
    && find /tmp /var/tmp -mindepth 1 -maxdepth 1 -exec rm -rf {} +

RUN go install google.golang.org/protobuf/cmd/protoc-gen-go@latest \
    && go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest \
    && go install github.com/fullstorydev/grpcurl/cmd/grpcurl@latest \
    && go install github.com/bufbuild/buf/cmd/buf@latest \
    && go clean -cache -modcache -testcache \
    && rm -rf /root/.cache/go-build /root/go/pkg/mod \
    && find /tmp /var/tmp -mindepth 1 -maxdepth 1 -exec rm -rf {} +

ENV EDITOR=vim
ENV VISUAL=vim
ENV GIT_EDITOR=vim

EXPOSE 22
WORKDIR /workspace
