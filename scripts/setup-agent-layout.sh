#!/usr/bin/env bash
set -euo pipefail

mkdir -p \
  "$HOME/.agents/skills" \
  "$HOME/.claude/skills" \
  "$HOME/.codex/skills" \
  "$HOME/projects"

chmod 700 "$HOME/.claude" "$HOME/.codex" 2>/dev/null || true

cat <<EOF
Agent layout ready:

  $HOME/.agents/skills   shared skills
  $HOME/.claude/skills   Claude-specific skills
  $HOME/.codex/skills    Codex-specific skills
  $HOME/projects         HAPI workspace root

Next:
  1. Install/authenticate Claude Code and Codex on this server.
  2. Sync skills from your local machine.
  3. Register MCP servers in each agent's native config.
  4. Start HAPI Runner with this same Linux user.
EOF
