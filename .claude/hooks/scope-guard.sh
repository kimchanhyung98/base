#!/bin/bash

INPUT=$(cat)
TOOL_NAME=$(echo "$INPUT" | jq -r '.tool_name')

PROJECT_ROOT="${CLAUDE_PROJECT_DIR:-$(pwd)}"
RESOLVED_ROOT=$(cd "$PROJECT_ROOT" 2>/dev/null && pwd -P) || RESOLVED_ROOT="$PROJECT_ROOT"

deny() {
  jq -n \
    --arg reason "Blocked: $1" \
    '{
      hookSpecificOutput: {
        hookEventName: "PreToolUse",
        permissionDecision: "deny",
        permissionDecisionReason: $reason
      }
    }'
  exit 0
}

# 경로를 절대 경로로 정규화
resolve_path() {
  local p="${1/#\~/$HOME}"
  [[ "$p" != /* ]] && p="$PROJECT_ROOT/$p"
  local dir
  dir=$(cd "$(dirname "$p")" 2>/dev/null && pwd -P) && echo "$dir/$(basename "$p")" || echo "$p"
}

# 프로젝트 외부 경로 여부 판별
is_outside_project() {
  local resolved
  resolved=$(resolve_path "$1")
  [[ "$resolved" != "$RESOLVED_ROOT"* ]]
}

# Write|Edit: file_path 검증
if [[ "$TOOL_NAME" == "Write" || "$TOOL_NAME" == "Edit" ]]; then
  FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty')
  [ -z "$FILE_PATH" ] && exit 0

  if is_outside_project "$FILE_PATH"; then
    deny "$FILE_PATH is outside the project directory ($RESOLVED_ROOT)."
  fi
  exit 0
fi

# Bash: rm 명령어의 대상 경로 검증
if [[ "$TOOL_NAME" == "Bash" ]]; then
  COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // empty')
  [ -z "$COMMAND" ] && exit 0

  # rm 구문에서 경로 인자를 추출하여 프로젝트 범위 확인
  if echo "$COMMAND" | grep -qE '\brm\b'; then
    RM_CMDS=$(echo "$COMMAND" | grep -oE '\brm\s+[^;&|]+')
    while IFS= read -r rm_cmd; do
      [ -z "$rm_cmd" ] && continue
      for arg in $rm_cmd; do
        [[ "$arg" == "rm" ]] && continue
        [[ "$arg" == -* ]] && continue

        if is_outside_project "$arg"; then
          deny "'rm' target '$arg' is outside the project directory ($RESOLVED_ROOT)."
        fi
      done
    done <<< "$RM_CMDS"
  fi
  exit 0
fi

exit 0
