# HAPI Mobile Dev Kit — English

A small setup kit for **phone-first AI coding with an always-on Linux server**.

The goal is simple: your laptop can be off while your coding agents keep running on a server you control.

> This is not internet-off development. The phone and server still need a network connection.

## Architecture

```text
iPhone / Android / Browser
            ↓
           HAPI
            ↓
Always-on Linux VM
            ↓
 HAPI Hub + Runner
            ↓
Claude Code · Codex · OpenCode
            ↓
      Git repositories
```

Oracle Cloud is one convenient option. Any always-on Linux host is fine.

## Setup

```bash
git clone https://github.com/rklpoi5678/hapi-mobile-dev-kit.git
cd hapi-mobile-dev-kit

./scripts/bootstrap-ubuntu.sh
./scripts/install-hapi-stack.sh
mkdir -p ~/projects
./scripts/install-services.sh ~/projects
./scripts/doctor.sh
```

Install the agents you want to use:

```bash
npm install -g @openai/codex
npm install -g @anthropic-ai/claude-code
```

Authenticate each agent once on the server. OpenCode is installed by `install-hapi-stack.sh`.

## Use from your phone

1. Pair the HAPI web/native client.
2. Create a new session.
3. Select the server.
4. Choose `~/projects/<repo>`.
5. Pick Claude Code, Codex, OpenCode, or another installed agent.
6. Work normally; approvals, files, Git and agent output stay on the server.

A first smoke test:

```text
Read README.md, make one harmless edit, and show me the diff. Do not commit yet.
```

## Skills, plugins, MCP

HAPI discovers skills from the same server environment used by the agent.

```text
~/.agents/skills/      shared skills
~/.claude/skills/      Claude-specific skills
~/.codex/skills/       Codex-specific skills
```

Project-local equivalents such as `.agents/skills`, `.claude/skills`, and `.codex/skills` can travel with a repository.

Plugins and MCP servers remain agent-native. Configure them in Claude Code or Codex first, verify they work in that CLI, then use the same agent through HAPI.

This separation is intentional:

```text
Agent CLI = capabilities, auth, plugins, MCP
HAPI      = remote sessions, approvals, files, mobile control
```

## Obsidian vs HAPI

They solve different problems.

**Obsidian**
- long-term notes
- planning
- design docs
- research
- RAG / knowledge base

**HAPI**
- running agents
- editing code
- tests and terminal work
- approvals
- remote execution from a phone

The planned bridge is selective: send only task-relevant context from the knowledge layer into an agent session. Do not turn the whole Obsidian vault into HAPI state.

## Roadmap

### 1. Stable phone-first runtime
- always-on Linux / Oracle deployment
- systemd Hub + Runner
- Claude Code, Codex, OpenCode
- reproducible diagnostics

### 2. Agent bootstrap
- one-command setup for shared skills
- reproducible Claude/Codex config
- MCP registration templates
- plugin inventory and health checks

### 3. Knowledge bridge
- Obsidian remains the source of truth for planning and long-term memory
- task-scoped context can be pulled into HAPI sessions
- optional RAG instead of full-vault synchronization

### 4. Decision layer
Use `agent-decision-workbench` as an orchestration/control layer:

```text
User / Supervisor
      ↓
CAO orchestration
  ↙          ↘
Developer   Reviewer
      ↓
Jev Evaluate State
      ↓
Final decision / retry
```

The preferred integration is **MCP or CLI sidecar**, not a HAPI fork. HAPI remains the remote execution surface; Jev remains the decision/evaluation layer.

## Provider note

Validate a provider directly in its agent CLI before debugging HAPI. HAPI cannot fix an upstream agent/provider compatibility issue.

## Security

- Never commit API keys or auth files.
- Keep `~/.hapi`, `~/.claude`, `~/.codex`, and provider credentials on the server.
- Keep real repositories under `~/projects`.
- Prefer HAPI's built-in relay unless you intentionally operate another tunnel.
