ARG IMAGE_SUFFIX=arm64
FROM dev-env:45-cuda-ml-${IMAGE_SUFFIX}

ARG DEBIAN_FRONTEND=noninteractive

ENV NVM_DIR=/root/.nvm
ENV PATH=/opt/node-current/bin:${PATH}

RUN apt-get update

RUN apt-get install -y --no-install-recommends \
      protobuf-compiler

RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/*

RUN git clone --depth=1 https://github.com/nvm-sh/nvm.git "${NVM_DIR}"

RUN . "${NVM_DIR}/nvm.sh" \
    && nvm install node \
    && nvm alias default node \
    && nvm use default \
    && node_bin="$(nvm which default)" \
    && node_home="$(dirname "$(dirname "${node_bin}")")" \
    && ln -sfn "${node_home}" /opt/node-current \
    && node --version \
    && npm --version

RUN . "${NVM_DIR}/nvm.sh" \
    && nvm use default \
    && npm install -g \
      typescript \
      ts-node \
      pnpm \
      yarn \
      yddict

RUN go install google.golang.org/protobuf/cmd/protoc-gen-go@latest
RUN go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest
RUN go install github.com/fullstorydev/grpcurl/cmd/grpcurl@latest
RUN go install github.com/bufbuild/buf/cmd/buf@latest

WORKDIR /workspace
