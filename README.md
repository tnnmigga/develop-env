# Layered Docker Development Environment

This repository builds a personal development image in layers, while keeping one final image per target architecture for daily use, such as `dev-env:latest-arm64` or `dev-env:latest-amd64`.

## Layer Order

1. `dev-env:ubuntu-base-<arch>`
   - Ubuntu LTS, locale, timezone, C/C++ build tools, pkg-config, and common command-line tools such as zsh, git, less, SSH, process tools, ping, net-tools, unzip, wget, and zip.
2. `dev-env:golang-<arch>`
   - Official Go toolchain, Go environment variables, `gopls`, `dlv`, `goimports`, `staticcheck`, `govulncheck`, `mockgen`, `gotests`, and `air`.
3. `dev-env:python-<arch>`
   - Python virtual environment, pip, uv, and IPython.
4. `dev-env:ml-<arch>`
   - NumPy, Pandas, scikit-learn, SciPy, and plotting libraries.
5. `dev-env:pytorch-<arch>`
   - PyTorch packages. Mac builds use CPU PyTorch; Win builds use CUDA PyTorch.
6. `dev-env:extra-tools-<arch>`
   - SSH server, Vim, default editor environment variables, nvm, Node.js, npm, TypeScript tooling, protobuf compiler, Go protobuf plugins, `buf`, and `grpcurl`.
7. `dev-env:dev-shell-<arch>`
   - Oh My Zsh, zsh plugins, and shell config.
8. `dev-env:latest-<arch>`
   - Final runtime defaults for daily interactive work.

## Quick Start

Build all layers:

```bash
make build
```

Build from a specific layer number:

```bash
make build stage=02
```

Build for a target host. The default build is for Mac arm64:

```bash
make build
make build-mac
make build-win
```

Available layer numbers:

```text
00 01 02 03 04 05 06 07
```

Dockerfile names keep the numeric order, while image tags use semantic names without numeric prefixes.

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

Connect to the running container over SSH. The container collects public keys from `/root/.ssh/authorized_keys` and `/root/.ssh/*.pub` at startup, then allows root login by key only:

```bash
ssh -p 2222 root@localhost
```

## Build Script

```bash
./scripts/build.sh mac 00
./scripts/build.sh win 05
```

The environment is intentionally mostly fixed in the Dockerfiles to keep the setup easy to read and maintain.

The extra tools layer installs nvm from its latest default branch, then installs the latest Node.js Current release through nvm:

```bash
make build stage=05
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

Mac images install PyTorch without CUDA. Win images install CUDA-enabled PyTorch packages, and GPU usage is controlled at runtime.

Run with GPU access:

```bash
make run-gpu
```

The CUDA PyTorch wheel source for Win builds is fixed in `dockerfiles/04-pytorch.Dockerfile`:

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
${HOME}/.develop/vscode-server:/root/.vscode-server
${HOME}/.gitconfig:/root/.gitconfig
${HOME}/.netrc:/root/.netrc
${HOME}/.codex/auth.json:/root/.codex/auth.json
${HOME}/.codex/config.toml:/root/.codex/config.toml
${HOME}/.ssh:/root/.ssh
```

It also publishes SSH on the host:

```yaml
2222:22
```

Override it when needed:

```bash
host_workspace=/path/to/projects \
host_history=/path/to/zsh-history-dir \
host_vscode_server=/path/to/vscode-server-dir \
host_gitconfig=/path/to/.gitconfig \
host_netrc=/path/to/.netrc \
host_codex_auth=/path/to/auth.json \
host_codex_config=/path/to/config.toml \
host_ssh_dir=/path/to/ssh-dir \
host_ssh_port=2223 \
docker compose up -d
```

Git global config is mounted at `/root/.gitconfig`, so commands such as `git config --global user.email ...` persist to the host config file.
The `.netrc` file is mounted at `/root/.netrc` for tools that read machine credentials from netrc.
Codex auth and config are mounted so the container can use the same login and settings without sharing the full host Codex state database and logs.
SSH config and keys are mounted so git over SSH can reuse host credentials.
The SSH server disables password authentication and uses the mounted public keys for passwordless login.

## Zsh Plugins

Enabled Oh My Zsh plugins:

```zsh
plugins=(git golang python pip virtualenv z extract colored-man-pages command-not-found zsh-autosuggestions zsh-syntax-highlighting)
```

Docker and Docker Compose zsh plugins are intentionally not enabled.
