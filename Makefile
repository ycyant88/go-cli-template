SHELL=/bin/bash

.PHONY: all build build-in-docker purge

DEBUG ?= false
BUILD_COMMIT_SHA ?= $(shell git rev-parse --short HEAD)
CLI_NAME ?= go-cli
CLI_VERSION ?= $(shell git describe --tags --abbrev=0 2>/dev/null || git rev-parse --short HEAD) # tag || commit-hash
GOURL ?= go-cli-starter
BUILDLOC ?= ./bin/$(CLI_NAME)
GO_LDFLAGS := -X $(GOURL)/cmd.name=$(CLI_NAME) -X $(GOURL)/cmd.version=$(CLI_VERSION)

export CLI_NAME ?= $(CLI_NAME)
export CGO_ENABLED ?= 0
export GOOS ?= linux

all:
	@echo "==> Nothing to do"

build:
	@echo "==> Go build"
	@go version
	@echo "BUILD_COMMIT_SHA=$(BUILD_COMMIT_SHA)"
	@echo "CLI_NAME=$(CLI_NAME)"
	@echo "CLI_VERSION=$(CLI_VERSION)"
	@echo "GO_LDFLAGS=$(GO_LDFLAGS)"
	@go build -trimpath -ldflags "$(GO_LDFLAGS) -X main.debugMode=$(DEBUG) -w -s" -o $(BUILDLOC) .

build-in-docker:
	@echo "==> Go build in docker"
	@echo "BUILD_COMMIT_SHA=$(BUILD_COMMIT_SHA)"
	@echo "CLI_NAME=$(CLI_NAME)"
	@echo "CLI_VERSION=$(CLI_VERSION)"
	@echo "GO_LDFLAGS=$(GO_LDFLAGS)"
	@docker buildx bake build

purge:
	@echo "==> Purging Go builds"
	@rm -fv bin/$(CLI_NAME)
	@rm -fv dist/${CLI_NAME}_*.tar
	@rm -fv dist/${CLI_NAME}
	@echo "==> Purged all Go builds"
