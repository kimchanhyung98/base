# Claude 작업 완료 알림 가이드

## 개요

Claude가 작업을 완료하면 로컬 시스템에서 알림을 받을 수 있습니다.  
멀티 세션을 지원하여 여러 작업이 동시에 진행되어도 각각의 완료 알림을 받을 수 있습니다.

## 기능

- **멀티 세션 지원**: 여러 작업을 동시에 추적
- **완료 이벤트 감지**: 작업 시작/완료/실패 상태 관리
- **크로스 플랫폼 알림**: macOS, Windows, Linux 지원
- **작업 정보 표시**: 레포지토리, 브랜치, 커밋 정보 포함

## 사용법

### CLI 명령어

```bash
# 작업 시작 (세션 ID 반환)
node .husky/notify-completion.cjs start "이슈 생성"

# 작업 완료 처리
node .husky/notify-completion.cjs complete <sessionId>

# 작업 실패 처리
node .husky/notify-completion.cjs fail <sessionId> "오류 메시지"

# 간단한 알림 발송
node .husky/notify-completion.cjs notify "PR 생성" "feature/new-feature"

# 활성 세션 목록 조회
node .husky/notify-completion.cjs list

# 오래된 세션 정리
node .husky/notify-completion.cjs cleanup
```

### 스크립트에서 사용

```javascript
const {startTask, completeTask, failTask, notify} = require('./.husky/notify-completion.cjs');

// 세션 기반 작업 추적
const sessionId = startTask('이슈 생성', {issueNumber: 123});
// ... 작업 수행 ...
completeTask(sessionId, {success: true});

// 간단한 알림
notify('PR 생성', '#42 feature/new-feature');
```

## 알림 예시

### 작업 완료 시

```
✅ Claude 작업 완료
📁 base/feature/new-feature
📝 이슈 생성
⏱️ 45초
💬 feat(issue): add new feature
```

### 작업 실패 시

```
❌ Claude 작업 실패
📁 base/feature/new-feature
📝 이슈 생성
⚠️ 권한 오류
```

## 플랫폼별 요구사항

| 플랫폼    | 알림 방식               | 추가 설치        |
|---------|---------------------|--------------|
| macOS   | osascript           | 없음           |
| Windows | PowerShell Toast    | Windows 10+  |
| Linux   | notify-send         | libnotify 설치 |

### Linux 설치

```bash
# Ubuntu/Debian
sudo apt-get install libnotify-bin

# Fedora
sudo dnf install libnotify

# Arch Linux
sudo pacman -S libnotify
```

## 설정

### 세션 저장 위치

세션 정보는 시스템 임시 디렉토리에 저장됩니다:

- macOS/Linux: `/tmp/claude-task-notifications/`
- Windows: `%TEMP%\claude-task-notifications\`

### 세션 타임아웃

오래된 세션은 60초 후 자동으로 정리됩니다.

## Git Hook 연동

post-commit hook에서 자동 알림:

```bash
#!/usr/bin/env sh

# 커밋 후 알림
node .husky/notify-completion.cjs notify "커밋 완료"
```
