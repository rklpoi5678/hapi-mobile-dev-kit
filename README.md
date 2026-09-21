# HAPI Mobile Dev Kit

Phone-first AI coding with an always-on Linux server, HAPI, OpenCode, and your existing coding-plan providers.

- 🇰🇷 [한국어](docs/ko/README.md)
- 🇺🇸 [English](docs/en/README.md)
- 🇯🇵 [日本語](docs/ja/README.md)

> This repository does **not** fork or redistribute HAPI. It installs and configures upstream HAPI and OpenCode for personal remote development.

## What this gives you

```text
iPhone / Android / PWA
          ↓
       HAPI Relay
          ↓
   Always-on Linux VM
          ↓
    HAPI Hub + Runner
          ↓
    OpenCode / Codex
          ↓
 Alibaba / BytePlus / other providers
          ↓
       Git repos
```

## Quick start

```bash
git clone <THIS_REPOSITORY_URL>
cd hapi-mobile-dev-kit
./scripts/bootstrap-ubuntu.sh
./scripts/install-hapi-stack.sh
mkdir -p ~/projects
./scripts/install-services.sh ~/projects
./scripts/doctor.sh
```

Then open the Hub URL printed by HAPI or scan its pairing QR code.

## Security

- Never commit API keys or `~/.hapi/settings.json`.
- HAPI access tokens and provider keys stay on your server.
- Keep your actual project repositories separate under `~/projects`.
- Start with HAPI's built-in encrypted relay instead of exposing port 3006 publicly.

## Upstream projects

- HAPI: https://github.com/tiann/hapi — AGPL-3.0-only
- OpenCode: https://opencode.ai/

This setup repository is MIT licensed. Upstream projects retain their own licenses.
