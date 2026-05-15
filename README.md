# Layered Docker Development Environment

This repository builds a personal development image in layers, while keeping one final image per target architecture for daily use, such as `dev-env:latest-arm64` or `dev-env:latest-amd64`.

## Layer Order

1. `dev-env:00-ubuntu-base-<arch>`
   - Ubuntu LTS, locale, timezone, and base packages.
2. `dev-env:10-dev-shell-<arch>`
   - zsh, Oh My Zsh, tmux, vim, git, fzf, ripgrep, fd, bat, jq, and shell config.
3. `dev-env:20-golang-<arch>`
   - Official Go toolchain, Go environment variables, `gopls`, `dlv`, `goimports`, `staticcheck`, `govulncheck`, `mockgen`, `gotests`, and `air`.
4. `dev-env:30-python-<arch>`
   - Python virtual environment, pip, uv, IPython, and JupyterLab.
5. `dev-env:40-ml-<arch>`
   - NumPy, Pandas, scikit-learn, SciPy, plotting libraries, and optional CPU PyTorch.
6. `dev-env:45-cuda-ml-<arch>`
   - CUDA-enabled PyTorch packages for GPU-capable hosts.
7. `dev-env:50-extra-tools-<arch>`
   - nvm, Node.js, npm, TypeScript tooling, protobuf compiler, Go protobuf plugins, `buf`, and `grpcurl`.
8. `dev-env:latest-<arch>`
   - Final runtime defaults for daily interactive work.

## Quick Start

Build all layers:

```bash
make build
```

Build from a specific layer number:

```bash
make build stage=30
```

Build for a target host. The default build is for Mac arm64:

```bash
make build
make build-mac
make build-win
```

Available layer numbers:

```text
00 10 20 30 40 45 50 90
```

Run the development container in the background. This removes the old container first, then recreates it from the current image:

```bash
make run
make run-mac
make run-win
```

Enter the running container:

```bash
docker compose exec dev zsh
```

## Build Script

```bash
./scripts/build.sh mac 00
./scripts/build.sh win 50
```

The environment is intentionally mostly fixed in the Dockerfiles to keep the setup easy to read and maintain.

The extra tools layer installs nvm from its latest default branch, then installs the latest Node.js Current release through nvm:

```bash
make build stage=50
```

Stop the container:

```bash
make stop
```

Clean local images and dangling build cache:

```bash
make clean
```

## GPU Runtime

The final image includes CUDA-enabled PyTorch packages by default. GPU usage is controlled at runtime.

Run with GPU access:

```bash
make run gpu=1
```

The CUDA PyTorch wheel source is fixed in `dockerfiles/45-cuda-ml.Dockerfile`:

```bash
https://download.pytorch.org/whl/cu128
```

## Docker Compose

The Makefile intentionally keeps only a small set of daily commands:

```text
make build
make run
make run-gpu
make exec
make stop
make clean
```

`make run` executes `docker compose down --remove-orphans`, then `docker compose up -d --force-recreate`.

`make run-gpu` does the same thing with `docker-compose.gpu.yml` enabled.

`make exec` enters the running container with zsh.

By default, Docker Compose maps a dedicated project folder into `/workspace`, and persists only zsh command history under a hidden host folder:

```yaml
${HOME}/Desktop/workspace:/workspace
${HOME}/.develop/zsh:/root/.cache/zsh
```

Override it when needed:

```bash
host_workspace=/path/to/projects \
host_history=/path/to/zsh-history-dir \
docker compose up -d
```

## Zsh Plugins

Enabled Oh My Zsh plugins:

```zsh
plugins=(git golang python pip virtualenv z extract colored-man-pages command-not-found zsh-autosuggestions zsh-syntax-highlighting)
```

Docker and Docker Compose zsh plugins are intentionally not enabled.
