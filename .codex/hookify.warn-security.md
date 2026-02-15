---
name: warn-security
enabled: true
event: file
action: warn
conditions:
    - field: new_text
      operator: regex_match
      pattern: console\.log\(|debugger;|var_dump\(|dd\(|print_r\(|(?i)(api[_-]?key|secret[_-]?key|password|token|auth[_-]?token)\s*[=:]\s*("[^"]{8,}"|'[^']{8,}')
---

⚠️ **Debug code or hardcoded secret detected**

Patterns requiring confirmation before commit have been detected:

- Debug code: `console.log`, `debugger`, `var_dump`, `dd`, `print_r`
- Hardcoded secrets: `api_key`, `password`, `token`, etc.

Please inform the user of the detected file paths and line numbers. Do not remove them directly as they may be intentional code.
