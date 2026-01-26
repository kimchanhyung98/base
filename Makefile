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

init: ## Setup Project environment
	@if command -v claude >/dev/null 2>&1; then \
		echo "Setting up claude-hud..."; \
		claude -p "/claude-hud:setup" --model=sonnet --dangerously-skip-permissions; \
	fi
	@if [ "$$(uname -s)" = "Darwin" ]; then \
		echo ""; \
		echo "[init] macOS 알림 권한 안내"; \
		echo "  - .claude/hooks/notify.sh 알림을 위해 터미널(iTerm, Terminal 등) 앱의 알림 권한이 필요합니다."; \
		echo "  - 시스템 설정 > 알림 > Terminal 또는 iTerm2 > 알림 허용"; \
		echo "  - 자동 설정은 지원되지 않으니, 위 경로에서 수동으로 허용해주세요."; \
		echo "  - Apple 가이드: https://support.apple.com/ko-kr/guide/mac-help/mchl39a47f66/mac"; \
	fi
	@if ! command -v docker >/dev/null 2>&1; then \
		echo "[init] 'docker' not found"; \
		exit 1; \
	fi; \
	if ! docker compose version >/dev/null 2>&1; then \
		echo "[init] 'docker compose' not found"; \
		exit 1; \
	fi; \
	if ! docker info >/dev/null 2>&1; then \
		echo "[init] Docker is not running. Please start Docker first."; \
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
