# HAPI Mobile Dev Kit

**Code from your phone. Your laptop can stay off.**

Run AI coding agents on an always-on Linux server and control them from iPhone, Android, or a browser through HAPI.

- 🇰🇷 [한국어](docs/ko/README.md)
- 🇺🇸 [English](docs/en/README.md)
- 🇯🇵 [日本語](docs/ja/README.md)

> “Offline” here means **laptop-independent**: the laptop can stay powered off. Your phone and server still need network access.

## Why

A laptop should not be the thing that keeps an AI coding session alive.

```text
Phone
  ↓
HAPI
  ↓
Always-on Linux VM
  ↓
Claude Code · Codex · OpenCode
  ↓
Your Git repositories
```

Oracle Cloud works well for this pattern, but any always-on Linux machine is fine.

## Quick start

```bash
git clone https://github.com/rklpoi5678/hapi-mobile-dev-kit.git
cd hapi-mobile-dev-kit

./scripts/bootstrap-ubuntu.sh
./scripts/install-hapi-stack.sh

mkdir -p ~/projects
./scripts/install-services.sh ~/projects
./scripts/doctor.sh
```

Then pair the HAPI client, choose a project under `~/projects`, and start an agent session.

Install and authenticate the agent CLIs you want to use on the server. HAPI controls those environments; it does not replace them.

## Skills, plugins, MCP

HAPI can discover shared and agent-specific skills from the server:

```text
Shared skills     ~/.agents/skills/
Claude skills     ~/.claude/skills/
Codex skills      ~/.codex/skills/
```

Keep agent-specific plugins and MCP servers in each agent's native configuration. Treat the server as the source of truth and HAPI as the remote control layer.

## Roadmap

- **Now** — phone → HAPI → always-on Linux → Claude Code / Codex / OpenCode
- **Next** — one-command bootstrap for shared skills, plugins, and MCP registrations
- **Knowledge** — Obsidian stays the long-term memory / planning layer; HAPI stays the execution layer
- **Decisions** — connect `agent-decision-workbench` so CAO can orchestrate workers and Jev can evaluate ambiguous choices
- **Integration** — prefer MCP/CLI sidecars over forking HAPI

See the language guides for setup details and the roadmap rationale.

## Scope

This repository does **not** fork or redistribute HAPI. It is a small setup and operations kit around upstream tools.

- HAPI: https://github.com/tiann/hapi
- OpenCode: https://opencode.ai/
- Codex: https://github.com/openai/codex
- Claude Code: https://docs.anthropic.com/en/docs/claude-code/

## Security

Never commit API keys, HAPI credentials, Claude/Codex auth files, or provider tokens. Keep real projects separate under `~/projects`.

## License

This setup repository is MIT licensed. Upstream projects retain their own licenses.
