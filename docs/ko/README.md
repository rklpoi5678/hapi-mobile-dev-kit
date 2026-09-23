# HAPI Mobile Dev Kit — 한국어

**노트북을 켜두지 않아도 폰에서 AI 코딩을 이어가기 위한 개인 개발환경**입니다.

핵심은 노트북 원격조종이 아닙니다. 항상 켜져 있는 Linux 서버에서 에이전트를 실행하고, HAPI로 iPhone/Android에서 제어합니다.

> 여기서 “오프라인”은 **노트북이 꺼져 있어도 된다**는 뜻입니다. 폰과 서버의 인터넷 연결은 필요합니다.

## 구조

```text
아이폰 / 안드로이드 / 브라우저
              ↓
             HAPI
              ↓
      항상 켜진 Linux VM
              ↓
       HAPI Hub + Runner
              ↓
 Claude Code · Codex · OpenCode
              ↓
          Git 저장소
```

Oracle Cloud VM은 이 구조에 잘 맞는 선택지 중 하나입니다. 항상 켜둘 수 있는 Linux 서버라면 무엇이든 사용할 수 있습니다.

## 설치

```bash
git clone https://github.com/rklpoi5678/hapi-mobile-dev-kit.git
cd hapi-mobile-dev-kit

./scripts/bootstrap-ubuntu.sh
./scripts/install-hapi-stack.sh
mkdir -p ~/projects
./scripts/install-services.sh ~/projects
./scripts/doctor.sh
```

원하는 에이전트도 서버에 설치합니다.

```bash
npm install -g @openai/codex
npm install -g @anthropic-ai/claude-code
```

각 에이전트는 서버에서 한 번 인증합니다. OpenCode는 `install-hapi-stack.sh`가 설치합니다.

## 폰에서 사용

1. HAPI 웹/네이티브 클라이언트를 페어링합니다.
2. **New Session**을 엽니다.
3. 서버를 선택합니다.
4. `~/projects/<repo>`를 선택합니다.
5. Claude Code, Codex, OpenCode 등 설치된 에이전트를 고릅니다.
6. 승인, 파일, Git, 실행 결과는 서버에서 처리됩니다.

첫 검증은 이 정도면 충분합니다.

```text
README.md를 읽고 의미 없는 한 줄을 수정한 뒤 git diff를 보여줘. 아직 commit하지 마.
```

## Skills · Plugins · MCP

HAPI는 에이전트와 같은 서버 환경에서 스킬을 찾습니다.

```text
~/.agents/skills/      공용 스킬
~/.claude/skills/      Claude 전용
~/.codex/skills/       Codex 전용
```

프로젝트 안의 `.agents/skills`, `.claude/skills`, `.codex/skills`도 저장소와 함께 관리할 수 있습니다.

플러그인과 MCP는 **HAPI에 다시 설치하는 것이 아니라 각 에이전트의 원래 설정에 등록**하는 방향이 기본입니다. Claude Code/Codex에서 먼저 정상 동작을 확인한 뒤 HAPI로 그 에이전트를 실행합니다.

```text
Agent CLI = 인증 · Skills · Plugins · MCP · 모델
HAPI      = 원격 세션 · 승인 · 파일 · 모바일 제어
```

## Obsidian vs HAPI

둘은 경쟁 관계가 아니라 역할이 다릅니다.

**Obsidian**
- 장기 기억
- 기획/설계 문서
- 조사 자료
- 회의 기록
- RAG / 지식베이스

**HAPI**
- 실제 에이전트 실행
- 코드 수정
- 테스트/터미널
- 승인
- 폰에서 원격 개발

앞으로도 Obsidian 전체를 HAPI에 복제하기보다, **현재 작업에 필요한 문맥만 선택해서 에이전트 세션으로 전달**하는 방향이 맞습니다.

## Roadmap

### 1. 폰 중심 실행환경 안정화
- Oracle/Linux 상시 실행
- systemd Hub + Runner
- Claude Code / Codex / OpenCode
- 진단 스크립트

### 2. Agent bootstrap
- 공용 Skills 자동 배치
- Claude/Codex 설정 재현
- MCP 등록 템플릿
- Plugin 상태 점검

### 3. Knowledge bridge
- Obsidian은 장기 기억과 기획의 source of truth
- HAPI는 실행 계층
- 필요한 문서만 task-scoped context로 전달
- 전체 Vault 동기화 대신 선택적 RAG

### 4. Decision layer
`agent-decision-workbench`를 HAPI 위의 판단/오케스트레이션 계층으로 연결합니다.

```text
사용자 / Supervisor
        ↓
   CAO orchestration
    ↙           ↘
Developer     Reviewer
        ↓
 Jev Evaluate State
        ↓
최종 판단 / 재시도
```

Jev를 HAPI 안에 직접 박아 넣기보다 **MCP 또는 CLI sidecar**로 연결하는 방향을 우선합니다. HAPI는 실행/UI, Jev는 애매한 선택을 평가하는 decision layer로 유지합니다.

## Provider 주의점

먼저 해당 Agent CLI에서 provider 호출이 정상인지 확인한 뒤 HAPI를 디버깅하세요. Agent와 provider 자체의 호환성 문제를 HAPI가 해결해주지는 않습니다.

## 보안

- API Key/Auth 파일을 Git에 올리지 않습니다.
- `~/.hapi`, `~/.claude`, `~/.codex`와 provider credential은 서버에 둡니다.
- 실제 프로젝트는 `~/projects` 아래에 분리합니다.
- 특별한 이유가 없다면 HAPI 기본 Relay부터 사용합니다.
