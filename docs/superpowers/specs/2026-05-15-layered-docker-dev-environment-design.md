# Layered Docker Dev Environment Design

## Goal

Build a personal Docker development environment that is maintained as multiple layered Dockerfiles, while exposing one final image for daily use.

## Recommended Approach

Use sequential Dockerfiles with local image tags between layers:

1. `00-ubuntu-base` starts from Ubuntu LTS and creates a repeatable base with locale, timezone, sudo, common build tools, and a non-root user.
2. `10-dev-shell` adds the interactive shell experience: zsh, tmux, editors, git, and common CLI tools.
3. `20-golang` installs an official Go toolchain and sets Go-related environment variables.
4. `30-python` adds Python, a virtual environment, pip, uv, IPython, and JupyterLab.
5. `40-ml` adds CPU-friendly machine-learning and scientific packages.
6. `90-final` pins the final runtime defaults so daily usage only needs `dev-env:latest`.

## Constraints

- The final user-facing image should be a single image tag.
- Intermediate images should remain debuggable and rebuildable.
- The first version should avoid GPU/CUDA and large optional ML packages by default.
- Python runtime tooling and machine-learning packages should live in separate Docker layers.
- The build should be driven by `make build` or `scripts/build.sh`.
- Local project files should be mounted into `/workspace`.

## Initial Scope

This first iteration creates the project skeleton and a working build path. It does not yet customize editors deeply, install Go language-server tools, add CUDA, or pin a full ML research stack beyond common CPU packages.

## Verification

The practical verification for this personal environment is a successful Docker build with `make build`.
