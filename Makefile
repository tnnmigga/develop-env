stage ?= 00
gpu ?= 0

compose_files = -f docker-compose.yml
ifeq ($(gpu),1)
compose_files += -f docker-compose.gpu.yml
endif

compose = docker compose $(compose_files)

.PHONY: build build-mac build-win run run-mac run-win run-gpu exec stop clean

build: build-mac

build-mac:
	./scripts/build.sh mac $(stage)

build-win:
	./scripts/build.sh win $(stage)

run: run-mac

run-mac:
	-docker_platform=linux/arm64 image_tag=latest-arm64 $(compose) down --remove-orphans
	docker_platform=linux/arm64 image_tag=latest-arm64 $(compose) up -d --force-recreate

run-win:
	-docker_platform=linux/amd64 image_tag=latest-amd64 $(compose) down --remove-orphans
	docker_platform=linux/amd64 image_tag=latest-amd64 $(compose) up -d --force-recreate

run-gpu:
	-$(MAKE) run-win gpu=1

exec:
	$(compose) exec dev zsh

stop:
	$(compose) down --remove-orphans

clean: stop
	-docker image rm \
		dev-env:00-ubuntu-base-arm64 \
		dev-env:10-dev-shell-arm64 \
		dev-env:20-golang-arm64 \
		dev-env:30-python-arm64 \
		dev-env:40-ml-arm64 \
		dev-env:45-cuda-ml-arm64 \
		dev-env:50-extra-tools-arm64 \
		dev-env:latest-arm64 \
		dev-env:00-ubuntu-base-amd64 \
		dev-env:10-dev-shell-amd64 \
		dev-env:20-golang-amd64 \
		dev-env:30-python-amd64 \
		dev-env:40-ml-amd64 \
		dev-env:45-cuda-ml-amd64 \
		dev-env:50-extra-tools-amd64 \
		dev-env:latest-amd64
	docker image prune -f
	docker builder prune -f
