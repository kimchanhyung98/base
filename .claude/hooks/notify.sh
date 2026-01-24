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
    local message="${1:-Task completed}"
    osascript -e "display notification \"$message\" with title \"$TITLE\" sound name \"$SOUND\""
}

notify "$(get_last_prompt)"
