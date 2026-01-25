---
name: block-packages
enabled: true
event: file
action: block
conditions:
    - field: file_path
      operator: regex_match
      pattern: node_modules/|vendor/|\.venv/|venv/|__pycache__/|\.git/
---

🛑 **Dependency folder edit blocked**

이 폴더의 파일은 직접 편집할 수 없습니다:

- `node_modules/`, `vendor/` - 패키지 매니저 관리 폴더
- `.venv/`, `venv/`, `__pycache__/` - Python 환경/캐시
- `.git/` - Git 내부 데이터

변경사항은 패키지 재설치 시 손실되며, 버전 관리에 포함되지 않습니다.
