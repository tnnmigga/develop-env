ARG IMAGE_SUFFIX=arm64
FROM dev-env:10-dev-shell-${IMAGE_SUFFIX}

ARG TARGET_ARCH=arm64

ENV GO_VERSION=1.26.3

RUN curl -fsSL "https://go.dev/dl/go${GO_VERSION}.linux-${TARGET_ARCH}.tar.gz" -o /tmp/go.tgz
RUN rm -rf /usr/local/go
RUN tar -C /usr/local -xzf /tmp/go.tgz
RUN rm /tmp/go.tgz
RUN /usr/local/go/bin/go version

ENV GOROOT=/usr/local/go
ENV GOPATH=/root/go
ENV GOBIN=/root/go/bin
ENV PATH=/usr/local/go/bin:/root/go/bin:${PATH}

RUN mkdir -p /root/go/bin /root/go/pkg /root/go/src

RUN go install golang.org/x/tools/gopls@latest
RUN go install github.com/go-delve/delve/cmd/dlv@latest
RUN go install golang.org/x/tools/cmd/goimports@latest
RUN go install honnef.co/go/tools/cmd/staticcheck@latest
RUN go install golang.org/x/vuln/cmd/govulncheck@latest
RUN go install go.uber.org/mock/mockgen@latest
RUN go install github.com/cweill/gotests/gotests@latest
RUN go install github.com/air-verse/air@latest

WORKDIR /workspace
