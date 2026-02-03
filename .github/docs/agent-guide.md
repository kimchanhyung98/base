# GitHub Copilot Custom Agents 가이드

GitHub Copilot의 Custom Agents를 활용하여 특정 작업에 전문화된 에이전트를 생성하고 활용하는 방법을 안내합니다.

## 목차

- [개요](#개요)
- [파일 구조](#파일-구조)
- [YAML Frontmatter 속성](#yaml-frontmatter-속성)
- [Tools 설정](#tools-설정)
- [기본 예시](#기본-예시)
- [권장 설정](#권장-설정)
- [주의사항](#주의사항)

## 개요

Custom Agents는 특정 개발 작업에 맞춤화된 전문 에이전트를 생성할 수 있는 기능입니다. 테스트 작성, 코드 리뷰, 문서화 등 특정 도메인에 집중하는 에이전트를 만들어 개발 생산성을 높일 수 있습니다.

### 지원 환경

- **GitHub.com**: Copilot coding agent (PR 생성, 이슈 할당 등)
- **VS Code**: Chat에서 직접 사용
- **JetBrains IDEs**: 공개 프리뷰
- **Eclipse**: 공개 프리뷰
- **Xcode**: 공개 프리뷰

## 파일 구조

### 파일 위치

| 범위 | 경로 |
|-----|-----|
| 레포지토리 | `.github/agents/*.agent.md` 또는 `.github/agents/*.md` |
| 조직(Organization) | `agents/*.agent.md` (루트 디렉토리) |
| 엔터프라이즈 | `agents/*.agent.md` (루트 디렉토리) |

### 파일명 규칙

- 파일명은 에이전트의 기본 이름으로 사용됨 (`.md` 또는 `.agent.md` 제외)
- 허용 문자: `.`, `-`, `_`, `a-z`, `A-Z`, `0-9`
- 예시: `test-specialist.agent.md`, `code-reviewer.md`

### 우선순위

동일한 이름의 에이전트가 여러 레벨에 존재할 경우, 낮은 레벨이 우선합니다:

```
레포지토리 > 조직(Organization) > 엔터프라이즈
```

## YAML Frontmatter 속성

에이전트 프로필은 YAML frontmatter와 Markdown 프롬프트로 구성됩니다.

```yaml
---
name: 에이전트-이름
description: 에이전트 설명 (필수)
tools: ["read", "edit", "search"]
target: github-copilot  # 선택사항
---

프롬프트 내용 (최대 30,000자)
```

### 속성 설명

| 속성 | 필수 | 설명 |
|-----|-----|-----|
| `name` | ❌ | 에이전트 이름 (미설정 시 파일명 사용) |
| `description` | ✅ | 에이전트의 기능과 전문 분야 설명 |
| `tools` | ❌ | 사용 가능한 도구 목록 (미설정 시 모든 도구 활성화) |
| `target` | ❌ | 사용 환경 지정 (`vscode` 또는 `github-copilot`) |
| `model` | ❌ | AI 모델 지정 (VS Code/IDE 전용, GitHub.com에서는 무시됨) |
| `mcp-servers` | ❌ | MCP 서버 설정 (조직/엔터프라이즈 레벨 전용) |

## Tools 설정

### 설정 방법

```yaml
# 모든 도구 활성화 (기본값)
tools: ["*"]

# 특정 도구만 활성화
tools: ["read", "edit", "search"]

# 모든 도구 비활성화
tools: []

# MCP 서버 도구 포함
tools: ["read", "edit", "playwright/*", "github/search_repositories"]
```

### Tool Aliases

| 별칭 | 호환 별칭 | 용도 |
|-----|---------|-----|
| `execute` | `shell`, `Bash`, `powershell` | 명령어 실행 |
| `read` | `Read`, `NotebookRead` | 파일 읽기 |
| `edit` | `Edit`, `MultiEdit`, `Write`, `NotebookEdit` | 파일 수정 |
| `search` | `Grep`, `Glob` | 파일/텍스트 검색 |
| `agent` | `custom-agent`, `Task` | 다른 에이전트 호출 |
| `web` | `WebSearch`, `WebFetch` | 웹 검색/조회 (Coding agent 미지원) |

### 기본 제공 MCP 서버

| 서버 | 사용 예시 | 설명 |
|-----|---------|-----|
| `github` | `github/*`, `github/search_repositories` | GitHub API 도구 (읽기 전용) |
| `playwright` | `playwright/*`, `playwright/browser_snapshot` | 브라우저 자동화 (localhost만 접근 가능) |

## 기본 예시

### 테스트 전문가 에이전트

```yaml
---
name: test-specialist
description: 테스트 커버리지와 품질 향상에 집중하는 테스트 전문가
---

테스트 전문가로서 포괄적인 테스트를 통해 코드 품질을 향상시키는 역할을 수행합니다.

## 책임 사항

- 기존 테스트 분석 및 커버리지 갭 식별
- 단위 테스트, 통합 테스트, E2E 테스트 작성
- 테스트 품질 검토 및 유지보수성 개선 제안
- 테스트의 독립성, 결정성, 문서화 보장
- 프로덕션 코드 수정 없이 테스트 파일에만 집중

## 규칙

- 명확한 테스트 설명 포함
- 언어와 프레임워크에 적합한 테스트 패턴 사용
- AAA(Arrange-Act-Assert) 패턴 준수
```

### 구현 계획 에이전트

```yaml
---
name: implementation-planner
description: 상세한 구현 계획과 기술 명세를 마크다운 형식으로 작성
tools: ["read", "search", "edit"]
---

기술 계획 전문가로서 포괄적인 구현 계획을 수립합니다.

## 책임 사항

- 요구사항 분석 및 실행 가능한 작업으로 분해
- 상세한 기술 명세 및 아키텍처 문서 작성
- 명확한 단계, 의존성, 일정이 포함된 구현 계획 생성
- API 설계, 데이터 모델, 시스템 상호작용 문서화

## 규칙

- 명확한 제목, 작업 분류, 수락 기준 포함
- 테스트, 배포, 잠재적 위험 고려
- 코드 구현보다 문서 작성에 집중
```

### PR 리뷰 에이전트

```yaml
---
name: pr-reviewer
description: Pull Request 코드 리뷰 전문가
tools: ["read", "search"]
---

Pull Request 리뷰 전문가로서 코드 품질과 일관성을 검토합니다.

## 리뷰 관점

- 코드 스타일 및 컨벤션 준수 여부
- 잠재적 버그 및 보안 취약점
- 성능 최적화 가능성
- 테스트 커버리지 적절성
- 문서화 필요성

## 리뷰 형식

- 구체적인 라인 번호와 함께 피드백 제공
- 개선 제안 시 코드 예시 포함
- 심각도 레벨 명시 (Critical, Major, Minor, Suggestion)
```

## 권장 설정

### 프로젝트 공통 에이전트 구성

이 레포지토리에서 권장하는 기본 에이전트 구성입니다:

1. **테스트 에이전트** (`test-specialist.agent.md`)
   - 테스트 작성 및 커버리지 향상 전담
   - 프로덕션 코드 수정 제한

2. **문서화 에이전트** (`documentation.agent.md`)
   - README, API 문서, 주석 작성 전담
   - 코드 변경 없이 문서만 수정

3. **리팩토링 에이전트** (`refactoring.agent.md`)
   - 코드 구조 개선 전담
   - 기능 변경 없이 코드 품질 향상

### 도구 제한 권장사항

| 에이전트 유형 | 권장 도구 | 이유 |
|-------------|---------|------|
| 리뷰 전용 | `["read", "search"]` | 코드 수정 방지 |
| 문서 작성 | `["read", "search", "edit"]` | 필요한 최소 권한 |
| 테스트 작성 | `["*"]` | 테스트 실행 필요 |
| 계획 수립 | `["read", "search", "edit"]` | 문서 작성 중심 |

## 주의사항

### 레포지토리 레벨 제한

- MCP 서버는 에이전트 프로필 내에서 직접 설정 불가
- 레포지토리 설정에서 미리 구성된 MCP 서버 도구만 사용 가능

### 프롬프트 작성 시 주의점

1. **명확한 역할 정의**: 에이전트의 책임 범위를 명확히 기술
2. **구체적인 지침**: 모호한 표현보다 구체적인 행동 지침 제공
3. **제약 조건 명시**: 하지 말아야 할 것도 명확히 기술
4. **출력 형식 지정**: 기대하는 결과물의 형식 정의

### 버전 관리

- 에이전트 프로필은 Git 커밋 SHA 기반으로 버전 관리됨
- 브랜치나 태그를 활용하여 다른 버전의 에이전트 생성 가능
- PR 내에서는 동일 버전의 에이전트가 일관되게 사용됨

## 참고 링크

- [Custom Agents configuration](https://docs.github.com/en/copilot/reference/custom-agents-configuration)
- [Create custom agents](https://docs.github.com/en/copilot/how-tos/use-copilot-agents/coding-agent/create-custom-agents)
- [awesome-copilot agents](https://github.com/github/awesome-copilot/tree/main/agents)
