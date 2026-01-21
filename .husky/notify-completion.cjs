#!/usr/bin/env node

/**
 * Claude 작업 완료 알림 스크립트
 *
 * 기능:
 * - 멀티 세션 지원
 * - 완료 이벤트 감지
 * - 시스템 알림 발생
 */

const {execSync, spawn} = require('child_process');
const fs = require('fs');
const path = require('path');
const os = require('os');

// 설정
const STATE_DIR = path.join(os.tmpdir(), 'claude-task-notifications');
const LOCK_TIMEOUT = 60000; // 60초

/**
 * 알림 상태 디렉토리 초기화
 */
function ensureStateDir() {
    if (!fs.existsSync(STATE_DIR)) {
        fs.mkdirSync(STATE_DIR, {recursive: true, mode: 0o700});
    }
}

/**
 * 세션 ID 생성
 * @returns {string} 고유 세션 ID
 */
function generateSessionId() {
    return `${Date.now()}-${process.pid}-${Math.random().toString(36).slice(2, 11)}`;
}

/**
 * 세션 파일 경로 반환
 * @param {string} sessionId - 세션 ID
 * @returns {string} 세션 파일 경로
 */
function getSessionFile(sessionId) {
    return path.join(STATE_DIR, `session-${sessionId}.json`);
}

/**
 * 세션 상태 저장
 * @param {string} sessionId - 세션 ID
 * @param {object} state - 세션 상태
 */
function saveSessionState(sessionId, state) {
    ensureStateDir();
    const sessionFile = getSessionFile(sessionId);
    fs.writeFileSync(sessionFile, JSON.stringify(state, null, 2), {mode: 0o600});
}

/**
 * 세션 상태 로드
 * @param {string} sessionId - 세션 ID
 * @returns {object|null} 세션 상태 또는 null
 */
function loadSessionState(sessionId) {
    const sessionFile = getSessionFile(sessionId);
    if (fs.existsSync(sessionFile)) {
        try {
            return JSON.parse(fs.readFileSync(sessionFile, 'utf8'));
        } catch {
            return null;
        }
    }
    return null;
}

/**
 * 세션 상태 삭제
 * @param {string} sessionId - 세션 ID
 */
function deleteSessionState(sessionId) {
    const sessionFile = getSessionFile(sessionId);
    if (fs.existsSync(sessionFile)) {
        fs.unlinkSync(sessionFile);
    }
}

/**
 * 오래된 세션 정리
 */
function cleanupOldSessions() {
    ensureStateDir();
    const files = fs.readdirSync(STATE_DIR);
    const now = Date.now();

    for (const file of files) {
        if (!file.startsWith('session-')) continue;

        const filePath = path.join(STATE_DIR, file);
        try {
            const stat = fs.statSync(filePath);
            if (now - stat.mtimeMs > LOCK_TIMEOUT) {
                fs.unlinkSync(filePath);
            }
        } catch {
            // 파일 접근 오류 무시
        }
    }
}

/**
 * 현재 Git 브랜치명 가져오기
 * @returns {string} 브랜치명
 */
function getCurrentBranch() {
    try {
        return execSync('git rev-parse --abbrev-ref HEAD', {encoding: 'utf8'}).trim();
    } catch {
        return 'unknown';
    }
}

/**
 * 현재 Git 레포지토리명 가져오기
 * @returns {string} 레포지토리명
 */
function getRepoName() {
    try {
        const remoteUrl = execSync('git config --get remote.origin.url', {encoding: 'utf8'}).trim();
        const match = remoteUrl.match(/\/([^/]+?)(?:\.git)?$/);
        return match ? match[1] : 'unknown';
    } catch {
        return 'unknown';
    }
}

/**
 * 마지막 커밋 정보 가져오기
 * @returns {object} 커밋 정보
 */
function getLastCommitInfo() {
    try {
        const hash = execSync('git rev-parse --short HEAD', {encoding: 'utf8'}).trim();
        const message = execSync('git log -1 --pretty=%s', {encoding: 'utf8'}).trim();
        const author = execSync('git log -1 --pretty=%an', {encoding: 'utf8'}).trim();
        return {hash, message, author};
    } catch {
        return {hash: 'unknown', message: 'unknown', author: 'unknown'};
    }
}

/**
 * 허용된 알림 명령어 목록
 */
const ALLOWED_COMMANDS = ['osascript', 'notify-send'];

/**
 * 알림 도구 사용 가능 여부 확인
 * @param {string} command - 확인할 명령어
 * @returns {boolean} 사용 가능 여부
 */
function isCommandAvailable(command) {
    // 허용된 명령어만 확인
    if (!ALLOWED_COMMANDS.includes(command)) {
        return false;
    }
    try {
        // shell: true를 사용하여 command -v로 확인 (POSIX 호환)
        execSync(`command -v ${command}`, {stdio: 'ignore', shell: true});
        return true;
    } catch {
        return false;
    }
}

/**
 * AppleScript용 문자열 이스케이프
 * @param {string} str - 이스케이프할 문자열
 * @returns {string} 이스케이프된 문자열
 */
function escapeAppleScript(str) {
    return str
        .replace(/\\/g, '\\\\')
        .replace(/"/g, '\\"')
        .replace(/\n/g, '\\n')
        .replace(/\r/g, '\\r');
}

/**
 * XML용 문자열 이스케이프
 * @param {string} str - 이스케이프할 문자열
 * @returns {string} 이스케이프된 문자열
 */
function escapeXml(str) {
    return str
        .replace(/&/g, '&amp;')
        .replace(/</g, '&lt;')
        .replace(/>/g, '&gt;')
        .replace(/"/g, '&quot;')
        .replace(/'/g, '&apos;')
        .replace(/\n/g, '&#10;');
}

/**
 * 시스템 알림 발송 (크로스 플랫폼)
 * @param {string} title - 알림 제목
 * @param {string} message - 알림 내용
 * @returns {boolean} 알림 발송 성공 여부
 */
function sendNotification(title, message) {
    const platform = os.platform();

    try {
        if (platform === 'darwin') {
            // macOS
            if (!isCommandAvailable('osascript')) {
                console.log('[알림] osascript를 찾을 수 없습니다.');
                return false;
            }
            const escapedTitle = escapeAppleScript(title);
            const escapedMessage = escapeAppleScript(message);
            const script = `display notification "${escapedMessage}" with title "${escapedTitle}"`;
            const child = spawn('osascript', ['-e', script], {detached: true, stdio: 'ignore'});
            child.on('error', () => {}); // 오류 무시
            child.unref();
        } else if (platform === 'win32') {
            // Windows (PowerShell)
            const escapedTitle = escapeXml(title);
            const escapedMessage = escapeXml(message);
            const psScript = `
                [Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType = WindowsRuntime] | Out-Null
                [Windows.Data.Xml.Dom.XmlDocument, Windows.Data.Xml.Dom.XmlDocument, ContentType = WindowsRuntime] | Out-Null
                $template = @"
                <toast>
                    <visual>
                        <binding template="ToastText02">
                            <text id="1">${escapedTitle}</text>
                            <text id="2">${escapedMessage}</text>
                        </binding>
                    </visual>
                </toast>
"@
                $xml = New-Object Windows.Data.Xml.Dom.XmlDocument
                $xml.LoadXml($template)
                $toast = [Windows.UI.Notifications.ToastNotification]::new($xml)
                [Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier("Claude Task").Show($toast)
            `;
            const child = spawn('powershell', ['-ExecutionPolicy', 'Bypass', '-Command', psScript], {
                detached: true,
                stdio: 'ignore'
            });
            child.on('error', () => {}); // 오류 무시
            child.unref();
        } else {
            // Linux (notify-send)
            if (!isCommandAvailable('notify-send')) {
                console.log('[알림] notify-send를 찾을 수 없습니다. libnotify를 설치하세요.');
                return false;
            }
            const child = spawn('notify-send', [title, message], {detached: true, stdio: 'ignore'});
            child.on('error', () => {}); // 오류 무시
            child.unref();
        }
        return true;
    } catch (err) {
        console.error(`알림 발송 실패: ${err.message}`);
        return false;
    }
}

/**
 * 작업 시작 등록
 * @param {string} taskType - 작업 유형
 * @param {object} taskInfo - 작업 정보
 * @returns {string} 세션 ID
 */
function startTask(taskType, taskInfo = {}) {
    cleanupOldSessions();

    const sessionId = generateSessionId();
    const state = {
        sessionId,
        taskType,
        taskInfo,
        startTime: new Date().toISOString(),
        status: 'in_progress',
        branch: getCurrentBranch(),
        repo: getRepoName()
    };

    saveSessionState(sessionId, state);
    console.log(`[Claude Task] 작업 시작: ${taskType} (세션: ${sessionId})`);

    return sessionId;
}

/**
 * 작업 완료 처리
 * @param {string} sessionId - 세션 ID
 * @param {object} result - 작업 결과
 */
function completeTask(sessionId, result = {}) {
    const state = loadSessionState(sessionId);
    if (!state) {
        console.error(`[Claude Task] 세션을 찾을 수 없습니다: ${sessionId}`);
        return;
    }

    const commit = getLastCommitInfo();
    const endTime = new Date();
    const durationMs = endTime - new Date(state.startTime);

    const title = '✅ Claude 작업 완료';
    const message = [
        `📁 ${state.repo}/${state.branch}`,
        `📝 ${state.taskType}`,
        `⏱️ ${Math.round(durationMs / 1000)}초`,
        commit.message !== 'unknown' ? `💬 ${commit.message}` : ''
    ].filter(Boolean).join('\n');

    sendNotification(title, message);

    state.status = 'completed';
    state.endTime = endTime.toISOString();
    state.durationMs = durationMs;
    state.result = result;
    state.commit = commit;
    saveSessionState(sessionId, state);

    console.log(`[Claude Task] 작업 완료: ${state.taskType} (${Math.round(durationMs / 1000)}초)`);

    // 완료된 세션 정리 (비동기, 프로세스 종료 차단 안 함)
    setImmediate(() => {
        deleteSessionState(sessionId);
    });
}

/**
 * 작업 실패 처리
 * @param {string} sessionId - 세션 ID
 * @param {string} error - 오류 메시지
 */
function failTask(sessionId, error) {
    const state = loadSessionState(sessionId);
    if (!state) {
        console.error(`[Claude Task] 세션을 찾을 수 없습니다: ${sessionId}`);
        return;
    }

    const endTime = new Date();
    const durationMs = endTime - new Date(state.startTime);

    const title = '❌ Claude 작업 실패';
    const message = [
        `📁 ${state.repo}/${state.branch}`,
        `📝 ${state.taskType}`,
        `⚠️ ${error}`
    ].join('\n');

    sendNotification(title, message);

    state.status = 'failed';
    state.endTime = endTime.toISOString();
    state.durationMs = durationMs;
    state.error = error;
    saveSessionState(sessionId, state);

    console.log(`[Claude Task] 작업 실패: ${state.taskType} - ${error}`);

    // 실패한 세션 정리 (비동기, 프로세스 종료 차단 안 함)
    setImmediate(() => {
        deleteSessionState(sessionId);
    });
}

/**
 * 활성 세션 목록 조회
 * @returns {object[]} 세션 목록
 */
function listSessions() {
    ensureStateDir();
    const files = fs.readdirSync(STATE_DIR);
    const sessions = [];

    for (const file of files) {
        if (!file.startsWith('session-')) continue;

        const filePath = path.join(STATE_DIR, file);
        try {
            const state = JSON.parse(fs.readFileSync(filePath, 'utf8'));
            sessions.push(state);
        } catch {
            // 파일 파싱 오류 무시
        }
    }

    return sessions;
}

/**
 * 간단한 알림 발송 (직접 호출용)
 * @param {string} taskType - 작업 유형
 * @param {string} message - 추가 메시지
 */
function notify(taskType, message = '') {
    const branch = getCurrentBranch();
    const repo = getRepoName();
    const commit = getLastCommitInfo();

    const title = '✅ Claude 작업 완료';
    const body = [
        `📁 ${repo}/${branch}`,
        `📝 ${taskType}`,
        commit.message !== 'unknown' ? `💬 ${commit.message}` : '',
        message ? `📌 ${message}` : ''
    ].filter(Boolean).join('\n');

    sendNotification(title, body);
    console.log(`[Claude Task] 알림 발송: ${taskType}`);
}

/**
 * 안전한 JSON 파싱
 * @param {string} jsonString - JSON 문자열
 * @param {*} defaultValue - 파싱 실패 시 기본값
 * @returns {*} 파싱된 객체 또는 기본값
 */
function safeJsonParse(jsonString, defaultValue = {}) {
    if (!jsonString) {
        return defaultValue;
    }
    try {
        return JSON.parse(jsonString);
    } catch (err) {
        console.error(`JSON 파싱 오류: ${err.message}`);
        return defaultValue;
    }
}

// CLI 처리
if (require.main === module) {
    const args = process.argv.slice(2);
    const command = args[0];

    switch (command) {
        case 'start':
            const taskType = args[1] || 'unknown';
            const taskInfo = safeJsonParse(args[2], {});
            const sessionId = startTask(taskType, taskInfo);
            console.log(sessionId);
            break;

        case 'complete':
            const completeSessionId = args[1];
            const result = safeJsonParse(args[2], {});
            if (!completeSessionId) {
                console.error('사용법: notify-completion.cjs complete <sessionId> [result]');
                process.exit(1);
            }
            completeTask(completeSessionId, result);
            break;

        case 'fail':
            const failSessionId = args[1];
            const error = args[2] || 'Unknown error';
            if (!failSessionId) {
                console.error('사용법: notify-completion.cjs fail <sessionId> <error>');
                process.exit(1);
            }
            failTask(failSessionId, error);
            break;

        case 'list':
            const sessions = listSessions();
            console.log(JSON.stringify(sessions, null, 2));
            break;

        case 'notify':
            const notifyType = args[1] || 'task';
            const notifyMessage = args[2] || '';
            notify(notifyType, notifyMessage);
            break;

        case 'cleanup':
            cleanupOldSessions();
            console.log('오래된 세션이 정리되었습니다.');
            break;

        default:
            console.log(`
Claude 작업 완료 알림 스크립트

사용법:
  node notify-completion.cjs <command> [options]

명령어:
  start <taskType> [taskInfo]  - 새 작업 세션 시작
  complete <sessionId> [result] - 작업 완료 처리
  fail <sessionId> <error>      - 작업 실패 처리
  list                          - 활성 세션 목록
  notify <taskType> [message]   - 간단한 알림 발송
  cleanup                       - 오래된 세션 정리

예시:
  node notify-completion.cjs start "이슈 생성"
  node notify-completion.cjs complete abc123
  node notify-completion.cjs notify "PR 생성" "feature/new-feature"
`);
    }
}

// 모듈 내보내기
module.exports = {
    startTask,
    completeTask,
    failTask,
    listSessions,
    notify,
    sendNotification,
    cleanupOldSessions
};
