# base

> Base project template with automated Git hooks, commit validation, and AI coding assistant configurations

## Overview

This is a language-agnostic base template project that provides:

- **Git Hooks**: Automated commit validation with Husky
- **EditorConfig**: Consistent coding styles across editors
- **AI Assistant Configurations**: Ready-to-use setups for Claude and Codex
- **GitHub Workflows**: Branch naming and PR title validation
- **Security**: Built-in secret scanning and security best practices

## Quick Start

### Initial Setup

```bash
# Run initialization
make init

# Install git hooks
npm install
```

### Available Commands

```bash
make help          # Show all available commands
make init          # Setup project environment
make check         # Run tests and lint checks
make speckit       # Install speckit for AI agent specification
```

## AI Assistant Configurations

This template includes configurations for multiple AI coding assistants:

### Claude (Anthropic)

Configuration in `.claude/` directory:
- Pre-configured settings and plugins
- Hookify rules for code quality
- Memory management for context persistence

See [.claude/README.md](.claude/) for details.

### Codex (OpenAI)

Configuration in `.codex/` directory:
- Language-agnostic settings
- Security scanning hooks
- Completion parameters configuration

See [.codex/README.md](.codex/README.md) for details.

## Project Structure

```
base/
├── .claude/              # Claude AI configuration
├── .codex/               # Codex AI configuration
├── .github/              # GitHub workflows and templates
│   ├── docs/            # Project documentation
│   └── workflows/       # CI/CD workflows
├── .husky/              # Git hooks
├── Makefile             # Build and setup commands
├── package.json         # Node.js dependencies
└── README.md            # This file
```

## Documentation

Additional documentation available in [.github/docs/](.github/docs/):

- [Repository Copilot Guide](.github/docs/repository-copilot-guide.md)
- [Branch Name Guide](.github/docs/branch-name-guide.md)
- [Pull Request Guide](.github/docs/pull-request-guide.md)

## Features

### EditorConfig Support

Consistent coding styles with `.editorconfig`:
- UTF-8 encoding
- LF line endings
- Trailing whitespace handling
- Language-specific indentation

### Git Hooks

Automated validation using Husky:
- Pre-commit hooks for code quality
- Commit message validation
- Branch name validation

### GitHub Actions

Automated workflows for:
- Branch name validation
- PR title validation
- Dependabot updates

## Security

Security features include:
- Secret scanning in AI assistant configs
- Protected file patterns in `.gitignore`
- Automatic debug code detection
- Best practices enforcement

## Contributing

1. Follow the branch naming convention (see [docs](.github/docs/branch-name-guide.md))
2. Create PRs following the template
3. Ensure all checks pass
4. Keep changes language-agnostic

## License

See [LICENSE](LICENSE) file for details.