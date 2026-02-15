# Codex Configuration Guide

This guide explains how to set up and use the Codex AI coding assistant configuration in this base template project.

## Overview

The `.codex/` directory contains a complete configuration setup for OpenAI Codex and compatible AI coding assistants. This configuration is:

- **Language-agnostic**: Works with any programming language
- **Security-focused**: Built-in secret scanning and security checks
- **Customizable**: Easy to adapt for specific project needs
- **Well-documented**: Clear examples and best practices

## Prerequisites

Before using Codex configuration:

1. **API Access**: You need access to OpenAI API or compatible service
2. **API Key**: Obtain an API key from your provider
3. **Git**: Version control setup for hooks
4. **Basic Understanding**: Familiarity with JSON configuration files

## Initial Setup

### 1. Copy Configuration Template

```bash
cp .codex/config/config.json.example .codex/config/config.json
```

### 2. Configure API Credentials

Edit `.codex/config/config.json`:

```json
{
  "apiKey": "sk-your-actual-api-key-here",
  "organization": "org-your-organization-id",
  "model": "gpt-4",
  "baseURL": "https://api.openai.com/v1",
  "maxTokens": 128000,
  "temperature": 0.7
}
```

**Security Note**: This file is automatically gitignored. Never commit API keys to version control.

### 3. Review Main Settings

Check `.codex/settings.json` and adjust as needed:

```json
{
  "security": {
    "scanForSecrets": true,
    "scanForDebugCode": true
  },
  "codeQuality": {
    "requireTests": false,
    "requireDocumentation": false,
    "followEditorConfig": true
  },
  "features": {
    "autoComplete": true,
    "codeReview": true,
    "refactoring": true
  }
}
```

## Configuration Options

### Security Settings

Control security scanning behavior:

```json
{
  "security": {
    "scanForSecrets": true,        // Detect hardcoded secrets
    "scanForDebugCode": true,      // Detect debug statements
    "blockedPatterns": [           // Custom regex patterns
      "(?i)api[_-]?key.*=.*"
    ],
    "protectedPaths": [            // Files to exclude
      ".env",
      "**/*.key"
    ]
  }
}
```

### Code Quality Settings

Configure code quality requirements:

```json
{
  "codeQuality": {
    "requireTests": false,           // Require test execution
    "requireDocumentation": false,   // Require doc updates
    "followEditorConfig": true,      // Respect .editorconfig
    "respectExistingStyle": true     // Auto-detect code style
  }
}
```

### Completion Parameters

Fine-tune AI generation:

```json
{
  "completion": {
    "temperature": 0.7,        // Creativity (0.0-1.0)
    "topP": 0.95,             // Nucleus sampling
    "frequencyPenalty": 0.0,  // Repetition penalty
    "presencePenalty": 0.0    // Topic penalty
  }
}
```

**Temperature Guide**:
- `0.0-0.3`: More deterministic, precise code
- `0.4-0.7`: Balanced creativity and precision
- `0.8-1.0`: More creative, experimental solutions

### Feature Toggles

Enable or disable features:

```json
{
  "features": {
    "autoComplete": true,            // Inline code completion
    "inlineCompletion": true,        // Complete as you type
    "codeExplanation": true,         // Explain code snippets
    "codeReview": true,              // Review suggestions
    "refactoring": true,             // Refactoring suggestions
    "testGeneration": false,         // Auto-generate tests
    "documentationGeneration": false // Auto-generate docs
  }
}
```

### Memory Management

Configure context persistence:

```json
{
  "memory": {
    "enabled": true,                  // Enable memory
    "path": ".codex/memory",          // Storage location
    "cleanupPeriodDays": 21,          // Auto-cleanup after
    "maxMemorySize": "100MB"          // Maximum size
  }
}
```

## Hookify Rules

Hookify rules provide automatic code quality checks. These are defined in `hookify.*.md` files.

### Available Rules

#### 1. block-packages (Enabled)

**Purpose**: Prevent editing dependency folders

**Blocks**:
- `node_modules/` (npm)
- `vendor/` (composer, go)
- `.venv/`, `venv/` (Python)
- `__pycache__/` (Python)
- `.git/` (Git internals)

**Example**: Trying to edit `node_modules/express/lib/application.js` will be blocked.

#### 2. warn-security (Enabled)

**Purpose**: Detect security issues

**Detects**:
- Debug code: `console.log()`, `debugger`, `var_dump()`, `dd()`, `print_r()`
- Hardcoded secrets: `api_key = "..."`, `password = "..."`, `token = "..."`

**Example**: Adding `const API_KEY = "sk-1234567890abcdef"` triggers a warning.

#### 3. require-tests (Disabled)

**Purpose**: Ensure tests are run before completion

**Detects**: Test commands in transcript:
- `npm test`, `yarn test`, `pnpm test`
- `pytest`
- `phpunit`, `pest`
- `go test`
- `cargo test`
- `make test`, `make check`

**Enable**: Change `enabled: false` to `enabled: true` in `.codex/hookify.require-tests.md`

#### 4. sync-docs (Disabled)

**Purpose**: Remind about documentation updates

**Triggers**: Changes to code files (*.js, *.py, *.go, etc.)

**Reminds to update**:
- README.md
- API documentation
- Architecture decision records (ADR)
- Technical specifications
- User guides

**Enable**: Change `enabled: false` to `enabled: true` in `.codex/hookify.sync-docs.md`

### Customizing Hookify Rules

Edit the YAML frontmatter in hookify files:

```markdown
---
name: my-custom-rule
enabled: true              # Enable/disable
event: file               # When to trigger (file, stop, commit)
action: warn              # What to do (warn, block)
conditions:
    - field: file_path
      operator: regex_match
      pattern: \.test\.js$
---

Your message here...
```

**Events**:
- `file`: Triggers on file changes
- `stop`: Triggers when task completes
- `commit`: Triggers before git commit

**Actions**:
- `warn`: Shows warning, allows continuation
- `block`: Shows error, prevents action

## Custom Hooks

Create custom hooks in `.codex/hooks/`:

### Example: Pre-commit Hook

Already included: `.codex/hooks/pre-commit.sh`

This hook:
1. Checks for debug code
2. Scans for hardcoded secrets
3. Validates against security patterns

To use in Git:

```bash
# Link to git hooks (optional)
ln -s ../../.codex/hooks/pre-commit.sh .git/hooks/pre-commit
```

### Creating Custom Hooks

1. Create script in `.codex/hooks/`
2. Make it executable: `chmod +x .codex/hooks/your-hook.sh`
3. Reference in `settings.json`:

```json
{
  "hooks": {
    "preCommit": [".codex/hooks/pre-commit.sh"],
    "preGenerate": [".codex/hooks/custom-check.sh"]
  }
}
```

## Integration with Project

### With EditorConfig

Codex respects `.editorconfig` when `followEditorConfig: true`:

```json
{
  "codeQuality": {
    "followEditorConfig": true
  }
}
```

Generated code will match:
- Indent style (spaces/tabs)
- Indent size
- Line endings (LF/CRLF)
- Charset (UTF-8)

### With Git

Enable Git integration:

```json
{
  "integrations": {
    "git": {
      "enabled": true,
      "autoStage": false,
      "commitMessageTemplate": "{{type}}: {{description}}"
    }
  }
}
```

**Commit Message Template Variables**:
- `{{type}}`: Change type (feat, fix, docs, etc.)
- `{{description}}`: Change description
- `{{scope}}`: Change scope (optional)

### With Linters

Enable linter integration:

```json
{
  "integrations": {
    "linters": {
      "enabled": true,
      "autoFix": false
    }
  }
}
```

Codex will:
- Respect existing linter configs (`.eslintrc`, `pyproject.toml`, etc.)
- Generate lint-compliant code
- Optionally auto-fix issues (`autoFix: true`)

### With Formatters

Enable formatter integration:

```json
{
  "integrations": {
    "formatters": {
      "enabled": true,
      "autoFormat": false
    }
  }
}
```

Codex will:
- Respect formatter configs (`.prettierrc`, `black.toml`, etc.)
- Generate formatted code
- Optionally auto-format (`autoFormat: true`)

## Multi-Language Support

This configuration works with any language:

### JavaScript/TypeScript
```json
{
  "preferences": {
    "preferredLanguages": ["typescript", "javascript"],
    "preferredFrameworks": ["react", "node"]
  }
}
```

### Python
```json
{
  "preferences": {
    "preferredLanguages": ["python"],
    "preferredFrameworks": ["django", "fastapi"]
  }
}
```

### Go
```json
{
  "preferences": {
    "preferredLanguages": ["go"],
    "preferredFrameworks": []
  }
}
```

Leave empty for auto-detection:
```json
{
  "preferences": {
    "preferredLanguages": [],
    "codingStyle": "auto-detect"
  }
}
```

## Best Practices

### 1. Security

✅ **Do**:
- Keep API keys in `config.json` (gitignored)
- Enable secret scanning
- Review security warnings
- Use environment variables for sensitive data

❌ **Don't**:
- Commit `config/config.json`
- Disable security scans in production
- Ignore security warnings
- Hardcode secrets in code

### 2. Code Quality

✅ **Do**:
- Enable `followEditorConfig`
- Respect existing code style
- Review generated code
- Run tests before committing

❌ **Don't**:
- Disable all quality checks
- Auto-accept all suggestions
- Skip code review
- Ignore failing tests

### 3. Memory Management

✅ **Do**:
- Enable memory for context persistence
- Set reasonable cleanup period (21 days)
- Monitor memory size
- Clean manually when needed

❌ **Don't**:
- Store sensitive data in memory
- Set cleanup period too short
- Let memory grow unbounded
- Commit memory contents

### 4. Customization

✅ **Do**:
- Customize hookify rules for your project
- Add project-specific patterns
- Document custom configurations
- Share settings with team

❌ **Don't**:
- Modify core settings without understanding
- Break language-agnostic nature
- Remove security features
- Make settings too restrictive

## Troubleshooting

### API Connection Failed

**Problem**: Cannot connect to API

**Solutions**:
1. Check API key in `config/config.json`
2. Verify organization ID if required
3. Test base URL: `curl https://api.openai.com/v1/models -H "Authorization: Bearer YOUR_KEY"`
4. Check network/firewall settings

### Hookify Rules Not Working

**Problem**: Rules not triggering

**Solutions**:
1. Verify `enabled: true` in rule frontmatter
2. Check regex patterns match your files
3. Review event types (file/stop/commit)
4. Test patterns with sample strings

### Memory Growing Large

**Problem**: `.codex/memory/` directory too large

**Solutions**:
1. Reduce `cleanupPeriodDays` in settings
2. Manually clean: `rm -rf .codex/memory/* && touch .codex/memory/.gitkeep`
3. Lower `maxMemorySize` limit
4. Review what's being stored

### Generated Code Style Mismatches

**Problem**: Code doesn't match project style

**Solutions**:
1. Enable `followEditorConfig: true`
2. Enable `respectExistingStyle: true`
3. Configure linter/formatter integration
4. Provide code examples in prompt

## Advanced Usage

### Custom Completion Profiles

Create different profiles for different tasks:

**Precise Code** (`.codex/profiles/precise.json`):
```json
{
  "temperature": 0.2,
  "topP": 0.9,
  "features": {
    "testGeneration": true
  }
}
```

**Creative Solutions** (`.codex/profiles/creative.json`):
```json
{
  "temperature": 0.9,
  "topP": 0.95,
  "features": {
    "refactoring": true
  }
}
```

### Project-Specific Overrides

Override settings per project:

1. Create `.codex/settings.local.json`
2. Override specific settings
3. File is gitignored, won't be committed

```json
{
  "codeQuality": {
    "requireTests": true
  }
}
```

### Team Sharing

Share configuration with team:

1. Commit `.codex/` directory (except `config/` and `memory/`)
2. Document team conventions in `.codex/README.md`
3. Use consistent settings across team
4. Version control hookify rules

## Examples

### Example 1: Enable Test Requirements

**Scenario**: Ensure all code changes are tested

**Steps**:
1. Edit `.codex/hookify.require-tests.md`
2. Change `enabled: false` to `enabled: true`
3. Now tests must be run before task completion

### Example 2: Add Custom Security Pattern

**Scenario**: Detect database connection strings

**Steps**:
1. Edit `.codex/settings.json`
2. Add pattern to `blockedPatterns`:

```json
{
  "security": {
    "blockedPatterns": [
      "mysql://.*@.*",
      "postgresql://.*@.*"
    ]
  }
}
```

### Example 3: Configure for Python Project

**Scenario**: Optimize for Python development

**Steps**:
1. Edit `.codex/settings.json`:

```json
{
  "preferences": {
    "preferredLanguages": ["python"],
    "preferredFrameworks": ["fastapi", "pytest"],
    "codingStyle": "black"
  },
  "codeQuality": {
    "requireTests": true
  }
}
```

2. Enable test requirement in hookify rules
3. Add Python-specific patterns if needed

## Further Reading

- [EditorConfig Documentation](https://editorconfig.org)
- [Git Hooks](https://git-scm.com/docs/githooks)
- [Regular Expressions](https://regex101.com)
- [JSON Schema](https://json-schema.org)

## Support

For issues or questions:
1. Check this documentation
2. Review `.codex/README.md`
3. Check project Makefile for commands
4. Review hookify rule definitions

## Version History

- **1.0.0**: Initial Codex configuration setup
  - Basic settings.json structure
  - Four hookify rules
  - Pre-commit hook
  - Configuration examples
