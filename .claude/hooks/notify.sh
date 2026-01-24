#!/bin/bash
set -euo pipefail

readonly HISTORY_FILE="$HOME/.claude/history.jsonl"
readonly TITLE="Claude"
readonly SOUND="Glass"
readonly MAX_LENGTH=25

get_last_prompt() {
    [[ -f "$HISTORY_FILE" ]] || return 1
    tail -1 "$HISTORY_FILE" | jq -r '.display // empty' 2>/dev/null | cut -c1-"$MAX_LENGTH"
}

notify() {
    local message="$1"
    if [[ -z "$message" ]]; then
        message="Task completed"
    fi
    local escaped_message="${message//\\/\\\\}"
    escaped_message="${escaped_message//\"/\\\"}"
    osascript -e "display notification \"$escaped_message\" with title \"$TITLE\" sound name \"$SOUND\""
}

notify "$(get_last_prompt)"
