# Codex Configuration

This directory contains configuration files for AI coding assistants compatible with OpenAI Codex and similar tools.

## Overview

This is a language-agnostic base template configuration that can be adapted for any programming language or framework.

## Directory Structure

```
.codex/
├── config/
│   └── config.json.example    # Example configuration for API keys and settings
├── hooks/
│   └── (custom hooks)         # Custom hooks for code generation events
├── memory/
│   └── .gitkeep              # Persistent context storage
├── settings.json             # Main configuration file
├── hookify.*.md              # Hook definitions for code quality
└── README.md                 # This file
```

## Configuration Files

### settings.json

Main configuration file containing:

- **Security**: Secret scanning, debug code detection, protected paths
- **Code Quality**: Test requirements, documentation requirements
- **Blocking**: Dependency folder protection
- **Completion**: Temperature, top_p, and other generation parameters
- **Features**: Enable/disable features like auto-complete, code review, etc.
- **Integrations**: Git, linters, formatters integration settings
- **Memory**: Context persistence configuration

### config/config.json.example

Template for API configuration. Copy to `config/config.json` and fill in your credentials:

```bash
cp .codex/config/config.json.example .codex/config/config.json
# Edit .codex/config/config.json with your API key
```

**Note**: `config/config.json` is gitignored to prevent credential leakage.

## Hookify Rules

Hookify rules are defined in `hookify.*.md` files and provide automatic code quality checks:

### hookify.block-packages.md

- **Enabled**: Yes
- **Action**: Block edits to dependency folders
- **Protects**: node_modules, vendor, .venv, venv, __pycache__, .git

### hookify.warn-security.md

- **Enabled**: Yes
- **Action**: Warn about potential security issues
- **Detects**: Debug code, hardcoded secrets

### hookify.require-tests.md

- **Enabled**: No (disabled by default)
- **Action**: Block task completion if tests not run
- **Detects**: Test command execution in transcript

### hookify.sync-docs.md

- **Enabled**: No (disabled by default)
- **Action**: Warn when code changes might require documentation updates
- **Triggers**: Changes to code files (*.js, *.py, *.go, etc.)

## Usage

### Basic Setup

1. Copy the example configuration:
   ```bash
   cp .codex/config/config.json.example .codex/config/config.json
   ```

2. Edit `config.json` with your API credentials

3. Customize `settings.json` for your project needs

### Enabling/Disabling Features

Edit `settings.json` to enable or disable features:

```json
{
  "features": {
    "autoComplete": true,
    "codeReview": true,
    "testGeneration": false
  }
}
```

### Customizing Hookify Rules

Enable or disable hookify rules by editing the `enabled` field in the frontmatter:

```markdown
---
name: require-tests
enabled: true  # Change to true to enable
---
```

## Security

Protected paths (automatically excluded):
- `.env` files
- Private keys (`*.pem`, `*.key`)
- Certificates (`*.crt`, `*.cer`, `*.p12`, `*.pfx`)
- Credential files (`credentials.json`, `auth.json`)

## Memory Management

The `memory/` directory stores persistent context:
- Automatic cleanup after 21 days (configurable)
- Maximum size: 100MB (configurable)
- Helps maintain context across sessions

## Best Practices

1. **Keep it language-agnostic**: This is a base template
2. **Use EditorConfig**: Respect existing `.editorconfig` settings
3. **Follow existing style**: Auto-detect coding style from project
4. **Security first**: Enable security warnings and secret scanning
5. **Test before commit**: Consider enabling `require-tests` hook

## Integration with Other Tools

This configuration works alongside:
- `.editorconfig` - Coding style rules
- `.gitignore` - File exclusion patterns
- `.github/` - GitHub Actions and workflows
- `Makefile` - Build and test commands

## Troubleshooting

### API Connection Issues

Check your `config/config.json`:
- Verify API key is correct
- Check organization ID if applicable
- Ensure baseURL is correct

### Hookify Rules Not Working

- Check `enabled` field in rule frontmatter
- Verify regex patterns match your use case
- Review file paths in conditions

### Memory Issues

Clear memory if needed:
```bash
rm -rf .codex/memory/*
touch .codex/memory/.gitkeep
```

## Contributing

When contributing changes:
1. Keep settings language-agnostic
2. Document any new hookify rules
3. Update this README for significant changes
4. Test with multiple programming languages

## References

- [EditorConfig](https://editorconfig.org)
- [Git Hooks](https://git-scm.com/docs/githooks)
- Project Makefile for common commands

## License

See project root LICENSE file.
