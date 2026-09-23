#!/usr/bin/env bash
set -euo pipefail

ORACLE_HOST="${ORACLE_HOST:-${1:-}}"
REMOTE_HOME="${REMOTE_HOME:-/home/ubuntu}"
SSH_PORT="${SSH_PORT:-22}"

if [ -z "$ORACLE_HOST" ]; then
  echo "Usage: ORACLE_HOST=ubuntu@SERVER ./scripts/doctor-agent-env.sh" >&2
  exit 1
fi

ssh -p "$SSH_PORT" "$ORACLE_HOST" bash -s -- "$REMOTE_HOME" <<'REMOTE'
set -u
REMOTE_HOME="$1"

echo "== binaries =="
for cmd in hapi claude codex opencode git node npm; do
  printf '%-12s ' "$cmd"
  if command -v "$cmd" >/dev/null 2>&1; then
    command -v "$cmd"
  else
    echo "missing"
  fi
done

echo
echo "== versions =="
hapi --version 2>/dev/null || hapi --help 2>/dev/null | head -n 1 || true
claude --version 2>/dev/null || true
codex --version 2>/dev/null || true
opencode --version 2>/dev/null || true

echo
echo "== skill inventory =="
for d in \
  "$REMOTE_HOME/.agents/skills" \
  "$REMOTE_HOME/.claude/skills" \
  "$REMOTE_HOME/.codex/skills"
do
  echo "-- $d"
  if [ -d "$d" ]; then
    find "$d" -mindepth 1 -maxdepth 2 -name SKILL.md -print | sort
  else
    echo "missing"
  fi
done

echo
echo "== HAPI services =="
systemctl --user --no-pager --full status hapi-hub.service 2>/dev/null | sed -n '1,12p' || true
systemctl --user --no-pager --full status hapi-runner.service 2>/dev/null | sed -n '1,12p' || true
REMOTE
