#!/bin/bash
# Claude Code task completion notification
# Enhanced version with prompt preview from history

set -euo pipefail

# Read stdin JSON input
INPUT=$(cat)

# Configuration
NOTIFY_SOUND="${CLAUDE_NOTIFY_SOUND:-Glass}"
NOTIFY_TITLE="${CLAUDE_NOTIFY_TITLE:-Claude Code}"
HISTORY_FILE="${HOME}/.claude/history.jsonl"
PROMPT_LENGTH=30

# Extract session_id from hook input
SESSION_ID=$(echo "$INPUT" | jq -r '.session_id // empty' 2>/dev/null)

# Get last prompt for this session from history.jsonl
get_prompt_preview() {
    if [[ -z "$SESSION_ID" ]] || [[ ! -f "$HISTORY_FILE" ]]; then
        echo ""
        return
    fi

    # Find the last entry for this session and get display field
    local prompt
    prompt=$(grep "\"sessionId\":\"$SESSION_ID\"" "$HISTORY_FILE" 2>/dev/null | tail -1 | jq -r '.display // empty' 2>/dev/null)

    if [[ -n "$prompt" ]]; then
        # Remove newlines and truncate
        local cleaned
        cleaned=$(echo "$prompt" | tr '\n' ' ' | sed 's/  */ /g')
        if [[ ${#cleaned} -gt $PROMPT_LENGTH ]]; then
            echo "${cleaned:0:$PROMPT_LENGTH}..."
        else
            echo "$cleaned"
        fi
    else
        echo ""
    fi
}

# Determine status based on stop reason
get_status() {
    local reason
    reason=$(echo "$INPUT" | jq -r '.stop_reason // empty' 2>/dev/null)

    case "$reason" in
        end_turn)     echo "✓" ;;
        max_tokens)   echo "⚠" ;;
        stop_sequence) echo "■" ;;
        tool_use)     echo "⚙" ;;
        *)            echo "●" ;;
    esac
}

# Get sound based on context
get_sound() {
    local reason
    reason=$(echo "$INPUT" | jq -r '.stop_reason // empty' 2>/dev/null)

    case "$reason" in
        end_turn)    echo "Glass" ;;
        max_tokens)  echo "Basso" ;;
        *)           echo "$NOTIFY_SOUND" ;;
    esac
}

# Main
STATUS=$(get_status)
PROMPT=$(get_prompt_preview)
SOUND=$(get_sound)

# Build message
if [[ -n "$PROMPT" ]]; then
    MESSAGE="${STATUS} ${PROMPT}"
else
    MESSAGE="${STATUS} Task completed"
fi

# Send notification
osascript -e "display notification \"${MESSAGE}\" with title \"${NOTIFY_TITLE}\" sound name \"${SOUND}\""

exit 0
