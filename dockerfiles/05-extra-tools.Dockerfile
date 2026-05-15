ARG IMAGE_SUFFIX=arm64
FROM dev-env:pytorch-${IMAGE_SUFFIX}

ARG DEBIAN_FRONTEND=noninteractive

ENV NVM_DIR=/root/.nvm
ENV PATH=/opt/node-current/bin:${PATH}

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
      protobuf-compiler \
    && apt-get clean \
    && find /var/lib/apt/lists -mindepth 1 -maxdepth 1 -exec rm -rf {} + \
    && find /tmp /var/tmp -mindepth 1 -maxdepth 1 -exec rm -rf {} +

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

WORKDIR /workspace
