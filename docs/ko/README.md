# 한국어 가이드

이 레포는 **폰만 있어도 내 프로젝트를 계속 처리하기 위한 개인 개발환경**을 재현합니다.

핵심은 노트북을 원격 조종하는 것이 아니라, 항상 켜져 있는 Linux 서버에서 AI 코딩 에이전트를 실행하고 HAPI로 iPhone/Android에서 제어하는 것입니다.

## 구조

```text
아이폰 / 안드로이드
        ↓
      HAPI
        ↓
Oracle Cloud 등 Linux 서버
        ↓
HAPI Hub + Runner
        ↓
OpenCode / Codex
        ↓
Alibaba Coding Plan / BytePlus Coding Plan
        ↓
Git 프로젝트
```

## 1. 서버 준비

Ubuntu 계열 서버를 기준으로 합니다.

```bash
./scripts/bootstrap-ubuntu.sh
./scripts/install-hapi-stack.sh
```

설치 후 다음을 확인합니다.

```bash
hapi --help
opencode -v
```

## 2. 프로젝트 폴더

```bash
mkdir -p ~/projects
cd ~/projects
# 실제 프로젝트를 clone
```

HAPI Runner는 `~/projects`만 탐색하도록 제한합니다.

## 3. Alibaba / BytePlus 연결

Alibaba는 공식 OpenCode Coding Plan 설정을 제공합니다. 예시는 `config/opencode.alibaba.example.json`을 참고하세요.

실제 API 키를 이 레포에 넣지 마세요. 서버의 `~/.config/opencode/opencode.json`에만 저장합니다.

BytePlus도 OpenCode를 Coding Plan 지원 도구로 공식 지원합니다. BytePlus 콘솔에서 발급한 전용 키와 최신 공식 OpenCode 설정값을 사용하세요. 제공사 설정은 바뀔 수 있으므로 이 레포는 키나 고정 엔드포인트를 대신 관리하지 않습니다.

## 4. HAPI 상시 실행

```bash
./scripts/install-services.sh ~/projects
```

상태 확인:

```bash
systemctl --user status hapi-hub
systemctl --user status hapi-runner
```

로그:

```bash
journalctl --user -u hapi-hub -f
journalctl --user -u hapi-runner -f
```

## 5. 폰 연결

첫 테스트는 PWA를 권장합니다.

- iPhone: Safari → HAPI URL → 공유 → 홈 화면에 추가
- Android: Chrome → HAPI URL → 앱 설치/홈 화면 추가

HAPI Hub는 기본적으로 `--relay`를 사용합니다. 포트 3006을 인터넷에 직접 공개하지 않아도 됩니다.

## 6. 실제 사용

폰에서 **New Session** → 서버 선택 → `~/projects/<project>` → OpenCode를 선택합니다.

첫 검증 프롬프트 예시:

```text
README.md 마지막에 "HAPI remote test"를 추가하고 git diff를 보여줘. 아직 commit하지 마.
```

이것이 성공하면 `폰 → HAPI → 서버 → OpenCode → 모델 제공사 → 실제 repo` 전체 경로가 정상입니다.

## 운영 원칙

- HAPI와 OpenCode는 upstream 업데이트를 그대로 따라갑니다.
- API 키는 절대 Git에 저장하지 않습니다.
- 실제 프로젝트와 이 설치 레포를 분리합니다.
- 처음에는 HAPI Relay를 사용하고, 문제가 있을 때만 Tailscale/Cloudflare Tunnel 등을 추가합니다.
