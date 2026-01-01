# Husky Git Hooks 가이드

## commit-msg (커밋 메시지 검증)

**실행 시점**: `git commit` 시 (커밋 생성 전)
**스크립트**: `validate-commit.cjs`
**형식**: `<type>(scope): <subject>` 또는 `<type>: <subject>`

### 허용 타입

| 타입 | 설명 | 예시 |
|------|------|------|
| `feat` | 새로운 기능 추가 | `feat: 사용자 인증 추가` |
| `fix` | 버그 수정 | `fix(api): null 응답 처리` |
| `docs` | 문서 수정 | `docs: 설치 가이드 업데이트` |
| `style` | 코드 스타일 변경 | `style: 코드 포맷팅` |
| `refactor` | 코드 리팩토링 | `refactor(auth): 로직 개선` |
| `test` | 테스트 추가/수정 | `test: 유닛 테스트 추가` |
| `chore` | 빌드/설정 변경 | `chore: 의존성 업데이트` |

### 예시

```bash
✅ feat: 사용자 인증 추가
✅ feat(auth): JWT 토큰 검증 추가
✅ fix(api): null 응답 처리
✅ docs: 설치 가이드 업데이트

❌ Add feature          # 타입 누락
❌ feat add feature     # 콜론 누락
❌ feat(): 기능 추가    # 빈 scope
```

## pre-push (브랜치명 검증)

**실행 시점**: `git push` 시 (푸시 전)
**스크립트**: `validate-branch.cjs`
**형식**: `<type>/<description>`

### 허용 타입

| 타입 | 설명 | 예시 |
|------|------|------|
| `feature` | 새로운 기능 개발 | `feature/user-authentication` |
| `fix` | 버그 수정 | `fix/login-bug` |
| `hotfix` | 긴급 버그 수정 | `hotfix/critical-security-issue` |
| `release` | 릴리스 준비 | `release/v1.0.0` |
| `refactor` | 코드 리팩토링 | `refactor/auth-logic` |
| `docs` | 문서 업데이트 | `docs/installation-guide` |
| `test` | 테스트 추가 | `test/unit-tests` |
| `chore` | 유지보수 작업 | `chore/update-deps` |
| `style` | 스타일 개선 | `style/format-code` |
| `copilot` | GitHub Copilot 지원 개발 | `copilot/add-validation` |
| `claude` | Claude AI 지원 개발 | `claude/refactor-api` |

### 보호 브랜치 (직접 푸시 허용)

`main`, `master`, `develop`, `staging`

### 예시

```bash
✅ feature/user-authentication
✅ fix/login-bug
✅ copilot/add-validation
✅ claude/refactor-api

❌ feature_user_auth    # 구분자 오류 (/ 사용)
❌ Feature/user-auth    # 대문자 사용 금지
❌ feature/User-Auth    # 설명에 대문자 사용 금지
❌ my-feature           # 타입 누락
```
