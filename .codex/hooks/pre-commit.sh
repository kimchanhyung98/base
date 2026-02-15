#!/bin/bash
# Codex Pre-commit Hook
# This hook runs before code generation to ensure security checks

set -e

CODEX_DIR=".codex"
SETTINGS_FILE="$CODEX_DIR/settings.json"

# Check if settings file exists
if [ ! -f "$SETTINGS_FILE" ]; then
    echo "⚠️  Warning: .codex/settings.json not found"
    exit 0
fi

# Check for debug code patterns
check_debug_code() {
    local files=$(git diff --cached --name-only --diff-filter=ACMR | grep -E '\.(js|ts|py|php|go|java|rb)$' || true)
    
    if [ -n "$files" ]; then
        for file in $files; do
            if grep -E 'console\.log\(|debugger;|var_dump\(|dd\(|print_r\(' "$file" >/dev/null 2>&1; then
                echo "⚠️  Debug code detected in: $file"
                echo "   Please review before committing"
            fi
        done
    fi
}

# Check for hardcoded secrets
check_secrets() {
    local files=$(git diff --cached --name-only --diff-filter=ACMR || true)
    
    # Pattern to detect hardcoded secrets: api_key, password, token with quoted values
    local secret_pattern='(api[_-]?key|secret[_-]?key|password|token)[[:space:]]*[=:][[:space:]]*["'\''][^"'\'']{8,}'
    
    if [ -n "$files" ]; then
        for file in $files; do
            if grep -iE "$secret_pattern" "$file" >/dev/null 2>&1; then
                echo "🔒 Possible hardcoded secret detected in: $file"
                echo "   Please use environment variables instead"
            fi
        done
    fi
}

echo "🔍 Running Codex pre-commit checks..."

# Run checks if security scanning is enabled
if command -v jq >/dev/null 2>&1; then
    SCAN_SECRETS=$(jq -r '.security.scanForSecrets // false' "$SETTINGS_FILE")
    SCAN_DEBUG=$(jq -r '.security.scanForDebugCode // false' "$SETTINGS_FILE")
    
    [ "$SCAN_SECRETS" = "true" ] && check_secrets
    [ "$SCAN_DEBUG" = "true" ] && check_debug_code
else
    # Fallback if jq not available
    check_secrets
    check_debug_code
fi

echo "✅ Pre-commit checks complete"
exit 0
