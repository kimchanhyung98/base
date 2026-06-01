#!/usr/bin/env bash
set -euo pipefail

command_text="$(jq -r '.tool_input.command // ""')"
normalized_command="$(printf '%s' "$command_text" | tr '\n\t' '  ' | sed -E 's/[[:space:]]+/ /g')"

if printf '%s\n' "$normalized_command" | grep -Eq '(^|[;&|][[:space:]]*)(git|/[[:alnum:]_./-]*/git)([[:space:]]+-C[[:space:]]+[^[:space:]]+)?[[:space:]]+push([[:space:]]|$|[;&|])'; then
  printf '%s\n' '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"deny","permissionDecisionReason":"Blocked git push by repository policy."}}'
fi
