---
name: sync-docs
enabled: false
event: file
action: warn
conditions:
    - field: file_path
      operator: regex_match
      pattern: \.(php|ts|tsx|js|jsx|py|svelte|cs|rs|go|java|rb)$
---

📝 **Documentation sync required**

Code has been changed. Check if related documentation needs to be **added or updated**:

- When adding new features → Documentation **creation** needed
- When modifying/deleting existing features → Documentation **update** needed

Consider updating:

- [ ] README.md - Main project documentation
- [ ] API documentation - If API changes were made
- [ ] Architecture decision records (ADR) - For significant architectural changes
- [ ] Technical specifications - For implementation details
- [ ] User guides - For user-facing changes
