# Pull Request 작성 가이드

제목 형식 : `<type>(<scope>): <description>`

## 규칙

- **소문자**로 시작
- **명령형 현재 시제** 사용 (add, 과거형 added가 아님)
- 마침표 **없음**
- **50자 이내** 권장

## 🏷️ Types

| Type       | 설명         | 예시                                           |
|------------|------------|----------------------------------------------|
| `feat`     | 새로운 기능 추가  | `feat(user): add email verification`         |
| `fix`      | 버그 수정      | `fix(payment): resolve timeout error`        |
| `docs`     | 문서 변경      | `docs(api): add OpenAPI spec`                |
| `style`    | 코드 스타일 변경  | `style(user): format with prettier`          |
| `refactor` | 코드 리팩토링    | `refactor(order): extract calculation logic` |
| `test`     | 테스트 추가/수정  | `test(user): add authentication tests`       |
| `chore`    | 기타 변경사항    | `chore(deps): upgrade Laravel to 12.1`       |
| `perf`     | 성능 개선      | `perf(database): optimize user query`        |
| `ci`       | CI/CD 변경   | `ci(github): add deployment workflow`        |
| `build`    | 빌드 시스템 변경  | `build(docker): update PHP to 8.5`           |
| `revert`   | 이전 커밋 되돌리기 | `revert(payment): revert payment feature`    |

## 🎯 Scopes

| Scope                                   | 설명      |
|-----------------------------------------|---------|
| `user`, `product`, `order`, `payment`   | 도메인 관련  |
| `auth`, `api`, `database`, `middleware` | 컴포넌트 관련 |
| `service`, `controller`, `model`        | 레이어 관련  |
| `docker`, `deps`, `config`, `github`    | 인프라 관련  |

## 예시

```
feat(user): add email verification
fix(payment): resolve timeout error
refactor(order): extract calculation logic
docs(api): add OpenAPI specification
chore(deps): upgrade Laravel to 12.1
```
