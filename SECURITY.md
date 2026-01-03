# Security Policy / 보안 정책

## Supported Versions / 지원 버전

We release patches for security vulnerabilities. As this is a base template repository, security policies apply to all active versions.

보안 취약점에 대한 패치를 릴리스합니다. 이것은 기본 템플릿 저장소이므로 보안 정책은 모든 활성 버전에 적용됩니다.

| Version | Supported          |
| ------- | ------------------ |
| latest  | :white_check_mark: |

## Reporting a Vulnerability / 취약점 보고

We take security seriously. If you discover a security vulnerability, please report it responsibly.

보안을 중요하게 생각합니다. 보안 취약점을 발견하면 책임감 있게 보고해 주세요.

### How to Report / 보고 방법

**Please do NOT report security vulnerabilities through public GitHub issues.**

**공개 GitHub 이슈를 통해 보안 취약점을 보고하지 마세요.**

Instead, please use one of the following methods:

대신 다음 방법 중 하나를 사용하세요:

1. **GitHub Security Advisories** (Preferred / 권장)
   - Go to the repository's Security tab / 저장소의 Security 탭으로 이동
   - Click "Report a vulnerability" / "Report a vulnerability" 클릭
   - Fill out the form with details / 세부 정보와 함께 양식 작성

2. **Direct Email / 직접 이메일**
   - Send details to the repository maintainers / 저장소 관리자에게 세부 정보 전송
   - Include "SECURITY" in the subject line / 제목에 "SECURITY" 포함

### What to Include / 포함할 내용

When reporting a vulnerability, please include:

취약점을 보고할 때 다음을 포함하세요:

- **Type of vulnerability** / 취약점 유형
- **Full path of source file(s)** related to the issue / 문제와 관련된 소스 파일의 전체 경로
- **Location of the affected source code** (tag/branch/commit or URL) / 영향을 받는 소스 코드의 위치 (태그/브랜치/커밋 또는 URL)
- **Step-by-step instructions to reproduce** / 재현을 위한 단계별 지침
- **Proof-of-concept or exploit code** (if possible) / 개념 증명 또는 악용 코드 (가능한 경우)
- **Impact of the issue** / 문제의 영향
- **How you think it could be exploited** / 악용될 수 있는 방법

### Response Timeline / 응답 일정

- **Initial Response**: Within 48 hours / 초기 응답: 48시간 이내
- **Status Update**: Within 7 days / 상태 업데이트: 7일 이내
- **Fix Timeline**: Depends on severity / 수정 일정: 심각도에 따라 다름
  - **Critical**: 24-48 hours / 치명적: 24-48시간
  - **High**: 7 days / 높음: 7일
  - **Medium**: 30 days / 중간: 30일
  - **Low**: 90 days / 낮음: 90일

### What to Expect / 예상되는 사항

After you submit a report:

보고서를 제출한 후:

1. We will acknowledge receipt of your report / 보고서 수령을 확인합니다
2. We will investigate and validate the issue / 문제를 조사하고 검증합니다
3. We will keep you informed of our progress / 진행 상황을 알려드립니다
4. We will notify you when the issue is fixed / 문제가 해결되면 알려드립니다
5. We will publicly disclose the issue after a fix is released / 수정이 릴리스된 후 문제를 공개합니다

### Recognition / 인정

We appreciate the security community's efforts to responsibly disclose vulnerabilities. With your permission, we will:

보안 커뮤니티의 책임감 있는 취약점 공개 노력에 감사드립니다. 귀하의 허가 하에 다음을 수행합니다:

- Credit you in our security advisory / 보안 권고에서 귀하를 인정
- Thank you in our release notes / 릴리스 노트에서 감사 인사
- Acknowledge your responsible disclosure / 책임감 있는 공개를 인정

## Security Best Practices / 보안 모범 사례

For contributors and users:

기여자와 사용자를 위한:

- Keep dependencies up to date / 종속성을 최신 상태로 유지
- Use strong, unique passwords / 강력하고 고유한 비밀번호 사용
- Enable two-factor authentication / 2단계 인증 활성화
- Review code changes carefully / 코드 변경 사항을 주의 깊게 검토
- Follow secure coding practices / 안전한 코딩 관행 준수

## Security Updates / 보안 업데이트

Security updates will be released as patch versions and announced through:

보안 업데이트는 패치 버전으로 릴리스되며 다음을 통해 공지됩니다:

- GitHub Security Advisories
- Release notes / 릴리스 노트
- Repository notifications / 저장소 알림

---

## References / 참고 문헌

This security policy follows guidelines from:
- [GitHub Security Advisories](https://docs.github.com/en/code-security/security-advisories)
- [OpenSSF Best Practices](https://openssf.org/)
- [CII Best Practices Badge Program](https://bestpractices.coreinfrastructure.org/)
