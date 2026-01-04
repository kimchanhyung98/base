# 브랜치명 검증 가이드

**실행 시점**: Pull Request 생성/수정 시 (자동)
**워크플로우**: `.github/workflows/branch-name-check.yml`
**형식**: `<type>/<description>` 또는 `<type>/<domain>/<description>`

## 허용 타입

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

## 보호 브랜치 (검사 제외)

`main`, `master`, `develop`, `staging`

## 브랜치명 규칙

### ✅ 올바른 형식

- **타입**: 위 표의 허용된 타입 중 하나 사용
- **구분자**: `/` (슬래시) 사용
- **허용 문자**: 소문자(a-z), 숫자(0-9), 하이픈(-), 점(.)

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

### ❌ 잘못된 형식

```bash
❌ Feature/Frontend/User-auth  # 타입, 도메인, 설명에 대문자 사용 금지
❌ my-feature                  # 타입 누락
❌ feature/add_function        # 언더스코어 사용 금지
❌ feature/a/b/c               # 4단계 이상 금지
❌ feature/                    # 설명 누락
```

## 검증 계층

| 계층             | 시점              | 우회 가능 여부                   |
|----------------|-----------------|----------------------------|
| 로컬 Husky       | `git push` 실행 시 | ✅ `--no-verify` 플래그로 우회 가능 |
| GitHub Actions | PR 생성/수정 시      | ❌ 필수 체크 (우회 불가)            |

## Branch Protection 설정 권장

**Settings → Branches → Branch protection rules**

1. `main` 브랜치에 보호 규칙 추가
2. **Require status checks to pass before merging** 활성화
3. **validate-branch-name** 체크 필수로 지정

이렇게 설정하면 브랜치명 규칙을 위반한 PR은 병합할 수 없습니다.
