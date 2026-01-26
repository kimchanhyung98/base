#!/bin/bash

# macOS 알림 권한 확인 스크립트

set -e

# 플래그 파일
FLAG_FILE=".claude/hooks/.permissions-checked"

# 이미 확인 완료한 경우 건너뛰기
[[ -f "$FLAG_FILE" ]] && exit 0

# 알림 권한 안내
echo ""
echo "Claude Code 작업 완료 알림을 받으려면 터미널 앱(iTerm/Terminal/VSCode 등)의 알림 권한이 필요합니다."
echo "알림 설정을 여시겠습니까? (n: 건너뛰기, 그 외: 열기)"
read -n 1 -r
echo ""

# n 입력 시 건너뛰기
if [[ $REPLY =~ ^[Nn]$ ]]; then
    mkdir -p "$(dirname "$FLAG_FILE")"
    touch "$FLAG_FILE"
    exit 0
fi

# 그 외 키 입력 시 알림 설정 열기
open "x-apple.systempreferences:com.apple.preference.notifications"

# 플래그 파일 생성
mkdir -p "$(dirname "$FLAG_FILE")"
touch "$FLAG_FILE"

sleep 2
exit 0
