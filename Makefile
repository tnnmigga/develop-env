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
	docker image prune -f

build-win:
	./scripts/build.sh win $(stage)
	docker image prune -f

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
		dev-env:ubuntu-base-arm64 \
		dev-env:golang-arm64 \
		dev-env:python-arm64 \
		dev-env:ml-arm64 \
		dev-env:pytorch-arm64 \
		dev-env:extra-tools-arm64 \
		dev-env:dev-shell-arm64 \
		dev-env:latest-arm64 \
		dev-env:ubuntu-base-amd64 \
		dev-env:golang-amd64 \
		dev-env:python-amd64 \
		dev-env:ml-amd64 \
		dev-env:pytorch-amd64 \
		dev-env:extra-tools-amd64 \
		dev-env:dev-shell-amd64 \
		dev-env:latest-amd64 \
		dev-env:ubuntu-base \
		dev-env:golang \
		dev-env:python \
		dev-env:ml \
		dev-env:pytorch \
		dev-env:extra-tools \
		dev-env:dev-shell \
		dev-env:latest \
		dev-env:test-base
	docker image prune -f
	docker builder prune -f
