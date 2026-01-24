---
name: sync-docs
enabled: true
event: file
action: warn
conditions:
    - field: file_path
      operator: regex_match
      pattern: app/Domains/[^/]+/(?!docs/).*\.(php|ts|js)$
---

📝 **Documentation sync required**

도메인 코드가 수정되었습니다. `app/Domains/{domain}/docs/` 문서 갱신이 필요한지 확인하세요:

- `adr/*.md` - 아키텍처 결정사항 변경 시
- `bpmn.md` - 비즈니스 프로세스 흐름 변경 시
- `planning.md` - 기능 계획/요구사항 변경 시
- `tech-spec.md` - 기술 명세/API 스펙 변경 시
