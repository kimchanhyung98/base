---
name: block-packages
enabled: true
event: file
action: block
conditions:
    - field: file_path
      operator: regex_match
      pattern: (^|/)(node_modules|vendor|\.venv|venv|__pycache__|\.git)/
---

🛑 **Dependency folder edit blocked**

This folder's files cannot be directly edited:

- `node_modules/`, `vendor/` - Package manager managed folders
- `.venv/`, `venv/`, `__pycache__/` - Python environment/cache
- `.git/` - Git internal data

Changes will be lost on package reinstallation and are not included in version control.
