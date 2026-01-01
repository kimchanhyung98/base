# base

## Speckit 사용 방법

Speckit CLI를 프로젝트 내에서 동일하게 사용할 수 있도록 Makefile로 래핑했습니다. Python 3와 make만 있으면 됩니다.

### 설치

로컬 가상환경(`.venv`)에 Speckit을 설치합니다. 필요 시 버전을 고정해 사용할 수 있습니다.

```bash
# 최신 버전
make speckit-install

# 특정 버전 설치
SPECKIT_VERSION=0.2.0 make speckit-install
```

### 초기화 및 검증

```bash
# 초기 설정 (예: 템플릿 생성)
make speckit-init

# 규칙 검증
make speckit-check
```

### 정리

```bash
make speckit-clean
```

### CI/워크플로우 예시 (옵션)

CI에서 동일한 명령을 재사용할 수 있습니다.

```yaml
steps:
  - uses: actions/checkout@v4
  - uses: actions/setup-python@v5
    with:
      python-version: '3.x'
  - run: make speckit-install
  - run: make speckit-check
```
