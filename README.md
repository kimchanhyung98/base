# base

## Husky hooks

이 프로젝트는 [Husky](https://typicode.github.io/husky)로 커밋 규칙을 강제합니다.

### 설치
```bash
npm install
```
설치 과정에서 `prepare` 스크립트가 실행되며 Husky 훅이 설정됩니다.

### 실행되는 훅
- `pre-commit`: `npm run lint`
- `pre-push`: `npm test`
- `commit-msg`: [Conventional Commits](https://www.conventionalcommits.org/) 규칙 검사

### 커밋 메시지 규칙
`<type>(<scope>): <subject>` 형식을 따라야 합니다. 예시:
- `feat: add user signup flow`
- `fix(api): handle empty payload`

허용 타입: `feat`, `fix`, `chore`, `docs`, `style`, `refactor`, `perf`, `test`, `build`, `ci`, `revert`, `ops`

### 참고
현재 `lint`와 `test` 스크립트는 자리표시자입니다. 팀 규칙에 맞게 실제 명령으로 대체해 사용해주세요.
