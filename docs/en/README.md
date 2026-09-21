# English guide

This repository recreates a **phone-first personal AI coding environment**.

Instead of remotely controlling a laptop, you run coding agents on an always-on Linux server and control them from iPhone or Android through HAPI.

## Architecture

```text
iPhone / Android
      ↓
     HAPI
      ↓
Always-on Linux server
      ↓
HAPI Hub + Runner
      ↓
OpenCode / Codex
      ↓
Alibaba / BytePlus coding plans
      ↓
Git repositories
```

## Install

```bash
./scripts/bootstrap-ubuntu.sh
./scripts/install-hapi-stack.sh
mkdir -p ~/projects
./scripts/install-services.sh ~/projects
./scripts/doctor.sh
```

Keep provider credentials only on the server. Do not commit API keys.

For Alibaba, copy `config/opencode.alibaba.example.json` to your OpenCode config location and replace the placeholder with your dedicated Coding Plan key.

For BytePlus, use the current official OpenCode integration values from the BytePlus Coding Plan console/docs.

## Mobile

Start with HAPI PWA:

- iPhone: Safari → Share → Add to Home Screen
- Android: Chrome → Install app / Add to Home Screen

Create a remote session, choose the machine, repository directory, and OpenCode/Codex agent.
