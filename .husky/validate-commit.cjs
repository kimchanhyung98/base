#!/usr/bin/env node

const fs = require('fs');

// 허용 규칙
const validTypes = ['feat', 'fix', 'docs', 'style', 'refactor', 'test', 'chore', 'build', 'ci', 'revert'];
const validPattern = '<type>(scope): <subject> or <type>: <subject>';

// 커밋 메시지 파일 확인
const commitMsgFile = process.argv[2];
if (!commitMsgFile) {
    console.error('커밋 메시지 파일 오류');
    process.exit(1);
}

// 커밋 메시지 확인
let commitMsg;
try {
    commitMsg = fs.readFileSync(commitMsgFile, 'utf8').trim();
} catch (err) {
    console.error('커밋 메시지 확인 오류');
    process.exit(1);
}

// 머지 커밋은 제외
if (commitMsg.startsWith('Merge')) {
    process.exit(0);
}

// 패턴: `type(scope): subject` or `type: subject` (scope는 선택 사항, 최소 2글자)
const commitPattern = new RegExp(`^(${validTypes.join('|')})(\\([a-zA-Z0-9_-]{2,}\\))?:\\s.+`);

if (!commitPattern.test(commitMsg)) {
    console.error(`* 잘못된 형식 : ${commitMsg}`);
    console.error(`* 올바른 형식 : ${validPattern}`);
    console.error(`* 허용 타입 : ${validTypes.join(', ')}`);
    console.error('');
    process.exit(1);
}

process.exit(0);
