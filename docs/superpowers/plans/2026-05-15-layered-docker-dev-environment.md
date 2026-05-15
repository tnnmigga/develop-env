# Layered Docker Dev Environment Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Create a basic layered Docker development environment whose final daily image is `dev-env:latest`.

**Architecture:** The project uses multiple Dockerfiles, each consuming the previous layer by local image tag. Python runtime tooling and ML packages are split into separate layers. A shell build script drives the sequence and the Makefile provides common entry points.

**Tech Stack:** Docker, Ubuntu 24.04 LTS, zsh, Go 1.26.3, Python 3 virtual environment, common CPU ML packages.

---

### Task 1: Add Layered Docker Skeleton

**Files:**
- Create: `dockerfiles/00-ubuntu-base.Dockerfile`
- Create: `dockerfiles/10-dev-shell.Dockerfile`
- Create: `dockerfiles/20-golang.Dockerfile`
- Create: `dockerfiles/30-python.Dockerfile`
- Create: `dockerfiles/40-ml.Dockerfile`
- Create: `dockerfiles/90-final.Dockerfile`
- Create: `config/zshrc`
- Create: `config/gitconfig`
- Create: `scripts/build.sh`
- Create: `Makefile`
- Create: `docker-compose.yml`
- Create: `.dockerignore`
- Create: `README.md`

- [x] **Step 1: Create Dockerfiles and config files**

Use Ubuntu as the base, add shell tools, install official Go, add Python runtime tooling, add ML packages in a separate layer, and expose `dev-env:latest` as the final image.

- [x] **Step 2: Make scripts executable**

Run: `chmod +x scripts/build.sh scripts/gpu-smoke-test.sh`

- [x] **Step 3: Verify build entrypoint syntax**

Run: `bash -n scripts/build.sh`
Expected: PASS with no syntax errors.
