ARG IMAGE_SUFFIX=arm64
FROM dev-env:ubuntu-base-${IMAGE_SUFFIX}

ARG TARGET_ARCH=arm64

ENV GO_VERSION=1.26.3

RUN curl -fsSL "https://go.dev/dl/go${GO_VERSION}.linux-${TARGET_ARCH}.tar.gz" -o /tmp/go.tgz \
    && rm -rf /usr/local/go \
    && tar -C /usr/local -xzf /tmp/go.tgz \
    && rm /tmp/go.tgz \
    && /usr/local/go/bin/go version \
    && find /tmp /var/tmp -mindepth 1 -maxdepth 1 -exec rm -rf {} +

ENV GOROOT=/usr/local/go
ENV GOPATH=/root/go
ENV GOBIN=/root/go/bin
ENV PATH=/usr/local/go/bin:/root/go/bin:${PATH}

RUN mkdir -p /root/go/bin /root/go/pkg /root/go/src

RUN go install golang.org/x/tools/gopls@latest \
    && go install github.com/go-delve/delve/cmd/dlv@latest \
    && go install golang.org/x/tools/cmd/goimports@latest \
    && go install honnef.co/go/tools/cmd/staticcheck@latest \
    && go install golang.org/x/vuln/cmd/govulncheck@latest \
    && go install go.uber.org/mock/mockgen@latest \
    && go install github.com/cweill/gotests/gotests@latest \
    && go install github.com/air-verse/air@latest \
    && go clean -cache -modcache -testcache \
    && rm -rf /root/.cache/go-build /root/go/pkg/mod \
    && find /tmp /var/tmp -mindepth 1 -maxdepth 1 -exec rm -rf {} +

WORKDIR /workspace
