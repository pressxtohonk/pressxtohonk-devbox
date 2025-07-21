SHELL := bash

.DEFAULT_GOAL := help

help: ## Show this help
	@awk 'BEGIN {FS = ":.*##"} /^[a-zA-Z0-9_-]+:.*##/ \
	{ printf "\033[36m%-20s\033[0m %s\n", $$1, $$2 }' $(MAKEFILE_LIST)

login: ## Authorize with fly.io
	flyctl auth login

create-secrets: ## Imports secrets from .env into devbox env vars
	cat .env | flyctl secrets import

create-volume: ## Creates a persistent volume for mounting in fly.toml
	flyctl volumes create data

build: ## Build the devbox image without deploying
	flyctl deploy --build-only

deploy: ## Build and deploy the devbox image
	flyctl deploy

start: ## Ensure a devbox instance is running
	flyctl scale count 1

stop: ## Ensure no devbox instances are running
	flyctl scale count 0

ssh: ## SSH into the devbox
	flyctl ssh console

tmux: ## SSH into the devbox and start a tmux session
	flyctl ssh console --pty -C "bash -l -c tmux"

