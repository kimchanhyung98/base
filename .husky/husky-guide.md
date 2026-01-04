# Husky Git Hooks 가이드

## commit-msg (커밋 메시지 검증)

**실행 시점**: `git commit` 시 (커밋 생성 전)
**스크립트**: `validate-commit.cjs`
**형식**: `<type>(scope): <subject>` 또는 `<type>: <subject>`

### 허용 타입

| 타입         | 설명               | 예시                            |
|------------|------------------|-------------------------------|
| `feat`     | 새로운 기능 추가        | `feat: 사용자 인증 추가`             |
| `fix`      | 버그 수정            | `fix(api): null 응답 처리`        |
| `docs`     | 문서 수정            | `docs: 설치 가이드 업데이트`           |
| `style`    | 코드 스타일 변경        | `style: 코드 포맷팅`               |
| `refactor` | 코드 리팩토링          | `refactor(auth): 로직 개선`       |
| `test`     | 테스트 추가/수정        | `test: 유닛 테스트 추가`             |
| `chore`    | 빌드/설정 변경         | `chore: 의존성 업데이트`             |
| `build`    | 빌드 시스템/외부 의존성 변경 | `build: webpack 설정 업데이트`      |
| `ci`       | CI 설정 파일/스크립트 변경 | `ci: GitHub Actions 워크플로우 추가` |
| `revert`   | 이전 커밋 되돌리기       | `revert: feat(auth) 커밋 되돌림`   |

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
**형식**: `<type>/<description>` 또는 `<type>/<domain>/<description>`
**허용 문자**: 소문자(a-z), 숫자(0-9), 하이픈(-), 점(.)

### 허용 타입

| 타입         | 설명                   | 예시                               |
|------------|----------------------|----------------------------------|
| `feature`  | 새로운 기능 개발            | `feature/user-authentication`    |
| `fix`      | 버그 수정                | `fix/login-bug`                  |
| `hotfix`   | 긴급 버그 수정             | `hotfix/critical-security-issue` |
| `release`  | 릴리스 준비               | `release/v1.0.0`                 |
| `refactor` | 코드 리팩토링              | `refactor/auth-logic`            |
| `docs`     | 문서 업데이트              | `docs/installation-guide`        |
| `test`     | 테스트 추가               | `test/unit-tests`                |
| `chore`    | 유지보수 작업              | `chore/update-deps`              |
| `style`    | 스타일 개선               | `style/format-code`              |
| `copilot`  | GitHub Copilot 지원 개발 | `copilot/add-validation`         |
| `claude`   | Claude AI 지원 개발      | `claude/refactor-api`            |

### 보호 브랜치 (직접 푸시 허용)

`main`, `master`, `develop`, `staging`

### 예시

#### 2단계 형식 (기본)

```bash
✅ feature/user-authentication
✅ fix/404-error
✅ copilot/add-validation
✅ claude/refactor-api
✅ hotfix/security-patch-2024
✅ release/1.0.0
```

#### 3단계 형식 (도메인 포함)

```bash
✅ feature/frontend/user-authentication
✅ fix/api/null-response
✅ refactor/backend/auth-logic
✅ docs/api/endpoint-guide
✅ test/integration/payment-flow
✅ fix/api/404-error
```

#### 잘못된 형식

```bash
❌ Feature/Frontend/User-auth  # 타입, 도메인, 설명에 대문자 사용 금지
❌ my-feature                  # 타입 누락
❌ feature/add_function        # 언더스코어 사용 금지
❌ feature/a/b/c               # 4단계 이상 금지
❌ feature/                    # 설명 누락
```
