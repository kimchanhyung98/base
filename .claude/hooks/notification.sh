#!/bin/bash
# Claude Code AskUserQuestion notification
# Displays the question content in macOS notification

set -euo pipefail

# Read stdin JSON input
INPUT=$(cat)

# Debug logging (optional - uncomment to debug)
echo "$INPUT" >> /tmp/claude-notification-debug.log
echo "---" >> /tmp/claude-notification-debug.log

# Configuration
NOTIFY_SOUND="${CLAUDE_NOTIFY_SOUND:-Purr}"
NOTIFY_TITLE="${CLAUDE_NOTIFY_TITLE:-Claude Code}"
QUESTION_LENGTH=30

# Extract question from transcript
get_question_from_transcript() {
    local transcript_path
    transcript_path=$(echo "$INPUT" | jq -r '.transcript_path // empty' 2>/dev/null)

    if [[ -z "$transcript_path" ]] || [[ "$transcript_path" == "null" ]] || [[ ! -f "$transcript_path" ]]; then
        echo "입력을 기다리고 있습니다"
        return
    fi

    # Find last AskUserQuestion tool call in transcript
    local question
    question=$(tail -100 "$transcript_path" 2>/dev/null | \
        jq -r '.message.content[]? | select(.type == "tool_use" and .name == "AskUserQuestion") | .input.questions[0].question' 2>/dev/null | \
        tail -1)

    if [[ -n "$question" ]] && [[ "$question" != "null" ]]; then
        # Remove newlines and truncate
        local cleaned
        cleaned=$(echo "$question" | tr '\n' ' ' | sed 's/  */ /g')
        if [[ ${#cleaned} -gt $QUESTION_LENGTH ]]; then
            echo "${cleaned:0:$QUESTION_LENGTH}..."
        else
            echo "$cleaned"
        fi
    else
        echo "입력을 기다리고 있습니다"
    fi
}

# Get question count from transcript
get_question_count() {
    local transcript_path
    transcript_path=$(echo "$INPUT" | jq -r '.transcript_path // empty' 2>/dev/null)

    if [[ -z "$transcript_path" ]] || [[ "$transcript_path" == "null" ]] || [[ ! -f "$transcript_path" ]]; then
        echo ""
        return
    fi

    local count
    count=$(tail -100 "$transcript_path" 2>/dev/null | \
        jq -r '.message.content[]? | select(.type == "tool_use" and .name == "AskUserQuestion") | .input.questions | length' 2>/dev/null | \
        tail -1)

    if [[ -n "$count" ]] && [[ "$count" != "null" ]] && [[ "$count" -gt 1 ]]; then
        echo " ($count개 질문)"
    else
        echo ""
    fi
}

# Main
QUESTION=$(get_question_from_transcript)
COUNT=$(get_question_count)
MESSAGE="💬 ${QUESTION}${COUNT}"

# Send notification
escaped_message=${MESSAGE//\"/\\\"}
escaped_title=${NOTIFY_TITLE//\"/\\\"}
escaped_sound=${NOTIFY_SOUND//\"/\\\"}
osascript -e "display notification \"${escaped_message}\" with title \"${escaped_title}\" sound name \"${escaped_sound}\""

exit 0
