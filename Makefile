.DEFAULT_GOAL := help

help: ## Show this help
	@awk 'BEGIN {FS = ":.*##"} /^[a-zA-Z0-9_-]+:.*##/ \
	{ printf "\033[36m%-20s\033[0m %s\n", $$1, $$2 }' $(MAKEFILE_LIST)

auth: ## Authenticate with fly.io
	flyctl auth login

init-app: ## First time setup, run this for new fly.io apps
	flyctl volumes list --json | grep '"name": "data"' \
		&& echo persistent volume already created \
		|| flyctl volumes create data --region sin
	cat .env | flyctl secrets import

build: ## Build the devbox image
	flyctl deploy --build-only --image-label devbox

deploy: ## Build and deploy the devbox image
	flyctl deploy --image registry.fly.io/$$(flyctl status -j | jq -r '.Name'):devbox

devbox: ## Ephemeral devbox machine, destroyed on disconnect
	flyctl machine run registry.fly.io/$$(flyctl status -j | jq -r '.Name'):devbox --shell --rm

session: session-bash ## Runs the default session with persistent storage (tmux)

session-tmux: ## SSH into a tmux session and suspend the devbox when done
	flyctl scale count 1
	flyctl machine start $$(flyctl machine list --json | jq -r '.[0].id')
	flyctl ssh console --pty -C "bash -l -c 'tmux new -A -s default'"
	flyctl machine suspend $$(flyctl machine list --json | jq -r '.[0].id')

session-bash: ## SSH into a bash shell and suspend the devbox when done
	flyctl scale count 1
	flyctl machine start $$(flyctl machine list --json | jq -r '.[0].id')
	flyctl ssh console
	flyctl machine suspend $$(flyctl machine list --json | jq -r '.[0].id')

scale-down: ## Scale to 1 CPU (shared), 256mb RAM
	flyctl scale vm shared-cpu-1x

scale-up: ## Scale to 1 CPU, 2gb RAM
	flyctl scale vm performance-1x

