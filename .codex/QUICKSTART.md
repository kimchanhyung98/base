# Codex Setup - Quick Start Guide

This quick start guide helps you get the Codex AI assistant configuration up and running.

## Prerequisites

- API access to OpenAI or compatible AI service
- Git installed
- Basic understanding of JSON

## 5-Minute Setup

### Step 1: Copy Configuration Template (30 seconds)

```bash
cp .codex/config/config.json.example .codex/config/config.json
```

### Step 2: Add Your API Key (1 minute)

Edit `.codex/config/config.json`:

```json
{
  "apiKey": "sk-your-actual-api-key-here",
  "organization": "org-your-org-id",
  "model": "gpt-4"
}
```

### Step 3: Verify Setup (30 seconds)

```bash
# Check structure
ls -la .codex/

# Verify settings
cat .codex/settings.json | head -20
```

### Step 4: Enable Optional Features (2 minutes)

Choose features to enable in `.codex/settings.json`:

**For production code:**
```json
{
  "codeQuality": {
    "requireTests": true,
    "requireDocumentation": true
  }
}
```

**For experimental work:**
```json
{
  "completion": {
    "temperature": 0.9
  },
  "features": {
    "refactoring": true,
    "testGeneration": true
  }
}
```

### Step 5: Optional - Enable Hookify Rules (1 minute)

To require tests before completion:

```bash
# Edit .codex/hookify.require-tests.md
# Change: enabled: false
# To:     enabled: true
```

## What You Get

✅ **Security**: Automatic secret and debug code detection  
✅ **Quality**: Consistent code style following .editorconfig  
✅ **Memory**: Context persistence across sessions  
✅ **Hooks**: Pre-commit security checks  
✅ **Documentation**: Comprehensive guides in .github/docs/

## Next Steps

1. **Read Full Guide**: See `.github/docs/codex-configuration-guide.md`
2. **Customize Settings**: Adjust `.codex/settings.json` for your needs
3. **Add Custom Hooks**: Create scripts in `.codex/hooks/`
4. **Share with Team**: Commit `.codex/` to version control

## Common Tasks

### Change AI Temperature

```json
// .codex/settings.json
{
  "completion": {
    "temperature": 0.7  // 0.0 = precise, 1.0 = creative
  }
}
```

### Enable Auto-formatting

```json
// .codex/settings.json
{
  "integrations": {
    "formatters": {
      "enabled": true,
      "autoFormat": true
    }
  }
}
```

### Set Language Preference

```json
// .codex/settings.json
{
  "preferences": {
    "preferredLanguages": ["python", "javascript"],
    "preferredFrameworks": ["fastapi", "react"]
  }
}
```

### Clean Memory

```bash
rm -rf .codex/memory/*
touch .codex/memory/.gitkeep
```

## Troubleshooting

**Cannot connect to API?**
- Check API key in `.codex/config/config.json`
- Verify baseURL is correct
- Test: `curl https://api.openai.com/v1/models -H "Authorization: Bearer YOUR_KEY"`

**Hookify rules not working?**
- Verify `enabled: true` in rule file
- Check regex patterns match your files
- Review event types

**Style mismatches?**
- Enable `followEditorConfig: true`
- Enable `respectExistingStyle: true`
- Configure linter integration

## Security Checklist

- [ ] API key stored in `config/config.json` (gitignored)
- [ ] No secrets committed to version control
- [ ] Security scanning enabled
- [ ] Protected paths configured
- [ ] Pre-commit hook tested

## Support

- **Full Documentation**: `.github/docs/codex-configuration-guide.md`
- **Config Details**: `.codex/README.md`
- **Examples**: See hookify.*.md files
- **Project Commands**: Run `make help`

---

**Setup Time**: ~5 minutes  
**Difficulty**: Easy  
**Language Support**: All languages  
**Framework Support**: Framework-agnostic
