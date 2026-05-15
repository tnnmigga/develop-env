#!/usr/bin/env bash
set -euo pipefail

image_name="dev-env"
final_tag="latest"
target="${1:-mac}"
stage="${2:-00}"

case "${target}" in
  mac)
    target="mac"
    target_arch="arm64"
    docker_platform="linux/arm64"
    image_suffix="arm64"
    ;;
  win)
    target="win"
    target_arch="amd64"
    docker_platform="linux/amd64"
    image_suffix="amd64"
    ;;
  *)
    echo "target must be mac or win" >&2
    exit 1
    ;;
esac

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "${ROOT_DIR}"

build_layer() {
  local dockerfile="$1"
  local tag="$2"
  shift 2

  printf '\n==> Building %s from %s\n' "${tag}" "${dockerfile}"
  docker build \
    --platform "${docker_platform}" \
    --file "${dockerfile}" \
    --tag "${tag}" \
    --build-arg "TARGET_ARCH=${target_arch}" \
    --build-arg "IMAGE_SUFFIX=${image_suffix}" \
    "$@" \
    .
}

layers=(
  "00|dockerfiles/00-ubuntu-base.Dockerfile|${image_name}:00-ubuntu-base-${image_suffix}"
  "10|dockerfiles/10-dev-shell.Dockerfile|${image_name}:10-dev-shell-${image_suffix}"
  "20|dockerfiles/20-golang.Dockerfile|${image_name}:20-golang-${image_suffix}"
  "30|dockerfiles/30-python.Dockerfile|${image_name}:30-python-${image_suffix}"
  "40|dockerfiles/40-ml.Dockerfile|${image_name}:40-ml-${image_suffix}"
  "45|dockerfiles/45-cuda-ml.Dockerfile|${image_name}:45-cuda-ml-${image_suffix}"
  "50|dockerfiles/50-extra-tools.Dockerfile|${image_name}:50-extra-tools-${image_suffix}"
  "90|dockerfiles/90-final.Dockerfile|${image_name}:${final_tag}-${image_suffix}"
)

case "${stage}" in
  0) stage="00" ;;
esac

if ! [[ "${stage}" =~ ^[0-9]+$ ]]; then
  echo "stage must be a numeric layer prefix, for example: 00, 10, 20, 30, 40, 45, 50, 90" >&2
  exit 1
fi

start_number=$((10#${stage}))
matched_start=""

for layer in "${layers[@]}"; do
  IFS="|" read -r number dockerfile tag <<< "${layer}"
  layer_number=$((10#${number}))

  if [ "${layer_number}" -eq "${start_number}" ]; then
    matched_start="yes"
    break
  fi
done

if [ -z "${matched_start}" ]; then
  echo "Unknown stage: ${stage}" >&2
  echo "Available layers: 00, 10, 20, 30, 40, 45, 50, 90" >&2
  exit 1
fi

for layer in "${layers[@]}"; do
  IFS="|" read -r number dockerfile tag <<< "${layer}"
  layer_number=$((10#${number}))

  if [ "${layer_number}" -ge "${start_number}" ]; then
    build_layer "${dockerfile}" "${tag}"
  fi
done

printf '\nBuilt final image: %s:%s-%s (%s, %s)\n' "${image_name}" "${final_tag}" "${image_suffix}" "${target}" "${docker_platform}"
