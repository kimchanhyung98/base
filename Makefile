.PHONY: spec-kit agent-os help init

.DEFAULT_GOAL := help

help: ## Show available commands
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n\nTargets:\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

spec-kit: ## Install spec-kit (default: claude)
	@agent=$(word 2,$(MAKECMDGOALS)); \
	if [ -z "$$agent" ]; then \
		agent="claude"; \
		echo "Using default agent: claude"; \
	fi; \
	if ! command -v specify >/dev/null 2>&1; then \
		echo "[spec-kit] 'specify' not found."; \
		echo "RUN: uv tool install specify-cli --from git+https://github.com/github/spec-kit.git"; \
		exit 1; \
	fi; \
	yes | specify init --here --ai $$agent --script sh

agent-os: ## Install agent-os (default: claude)
	@agent=$(word 2,$(MAKECMDGOALS)); \
	script="$$HOME/agent-os/scripts/project-install.sh"; \
	if [ -z "$$agent" ]; then \
		agent="claude"; \
		echo "Using default agent: claude"; \
	fi; \
	if [ ! -f "$$script" ]; then \
		echo "[agent-os] 'agent-os' not found."; \
		echo "RUN: curl -sSL https://raw.githubusercontent.com/buildermethods/agent-os/main/scripts/base-install.sh | bash"; \
		exit 1; \
	fi; \
	echo "Installing agent-os with agent: $$agent"; \
	if [ "$$agent" = "claude" ]; then \
		yes | bash "$$script"; \
	elif [ "$$agent" = "all" ]; then \
		yes | bash "$$script" --agent-os-commands true --standards-as-claude-code-skills true; \
	else \
		yes | bash "$$script" --claude-code-commands false --use-claude-code-subagents false --standards-as-claude-code-skills true --agent-os-commands true; \
	fi

init: ## Setup Project environment (Docker required)
	@if ! command -v docker >/dev/null 2>&1; then \
		echo "[init] 'docker' not found"; \
		exit 1; \
	fi; \
	if ! docker compose version >/dev/null 2>&1; then \
		echo "[init] 'docker compose' not found"; \
		exit 1; \
	fi; \
	if [ ! -f .env ]; then \
		echo "Copying .env.example to .env"; \
		cp .env.example .env; \
	fi; \
	if [ -f docker-compose.yml ]; then \
		echo "Starting Docker containers"; \
		docker compose up -d; \
	fi; \
	echo "Installing npm packages"; \
	docker run --rm -v $$(pwd):/app -w /app node:22-alpine sh -c "apk add --no-cache git && npm install"; \

%:
	@:
