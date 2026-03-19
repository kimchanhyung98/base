---
name: humanizer
description: 한국어/영어 문장을 더 자연스럽고 사람다운 톤으로 다듬는 문서 개선 스킬입니다.
---

# Humanizer (한국어/English)

한국어와 영어 문서를 더 자연스럽게 다듬을 때 사용하는 스킬입니다.  
Use this skill to rewrite Korean and English text so it sounds natural, clear, and human.

## 호출 방법 (How to invoke)

```text
/humanizer

[원문 또는 초안 붙여넣기]
```

또는 자연어로 요청해도 됩니다:

```text
이 문장을 자연스럽게 다듬어줘: [텍스트]
Please humanize this text: [text]
```

## 기본 동작 (Default behavior)

1. 원문의 **의미/사실/수치**는 유지합니다.
2. AI 티가 나는 과장, 상투 표현, 장황한 연결어를 줄입니다.
3. 독자 관점에서 읽기 쉬운 문장으로 정리합니다.
4. 문서 언어(한국어/영어)를 유지합니다.
5. 필요하면 문장을 분할하고, 중복 표현을 제거합니다.

## 편집 원칙 (Editing rules)

- 금지: 근거 없는 내용 추가, 사실 왜곡, 과도한 마케팅 톤
- 권장: 짧고 명확한 문장, 구체적인 표현, 자연스러운 연결
- 유지: 고유명사, 버전, 코드/명령어, 링크, 인용

## 출력 형식 (Output format)

기본적으로 아래 형식을 사용합니다:

```text
[Naturalized]
...수정된 본문...

[What changed]
- ...
- ...
```

문서 전체가 아닌 일부 문단만 요청하면 해당 범위만 수정합니다.

## 빠른 예시 (Quick examples)

### 한국어 예시

입력:
`해당 기능은 혁신적인 시너지를 창출하며 사용자 경험을 한 단계 끌어올립니다.`

출력:
`이 기능은 사용자가 작업을 더 빠르게 끝낼 수 있도록 돕습니다.`

### English example

Input:
`This groundbreaking feature marks a pivotal moment in user-centric innovation.`

Output:
`This feature helps users finish tasks faster and with fewer steps.`
