---
name: require-tests
enabled: false
event: stop
action: block
conditions:
    - field: transcript
      operator: not_contains
      pattern: npm test|yarn test|pnpm test|pytest|phpunit|pest|cargo test|go test|make test|make check
---

⚠️ **Tests not detected in transcript**

Test execution was not detected before completing the task.

To ensure your changes work correctly, run **one of the following** test commands appropriate for your project:

- JavaScript/TypeScript: `npm test`, `yarn test`, `pnpm test`
- PHP: `phpunit`, `pest`
- Python: `pytest`
- Go: `go test`
- Rust: `cargo test`
- Make: `make test`, `make check`
