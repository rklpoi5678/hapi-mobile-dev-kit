#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

ORACLE_HOST="${ORACLE_HOST:-${1:-}}"
REMOTE_HOME="${REMOTE_HOME:-/home/ubuntu}"
SSH_PORT="${SSH_PORT:-22}"
SSH_KEY="${SSH_KEY:-}"
SYNC_MODE="${SYNC_MODE:-merge}"       # merge | mirror
DRY_RUN="${DRY_RUN:-0}"               # 1 = rsync --dry-run

if [ -z "$ORACLE_HOST" ]; then
  cat >&2 <<'EOF'
Usage:
  ORACLE_HOST=ubuntu@SERVER ./scripts/sync-skills-to-oracle.sh

Optional:
  REMOTE_HOME=/home/ubuntu
  SSH_PORT=22
  SSH_KEY=/absolute/path/to/private.key
  SYNC_MODE=merge|mirror
  DRY_RUN=1
EOF
  exit 1
fi

for cmd in ssh rsync; do
  command -v "$cmd" >/dev/null 2>&1 || {
    echo "$cmd is required." >&2
    exit 1
  }
done

SSH=(ssh -p "$SSH_PORT")
RSYNC_RSH="ssh -p $SSH_PORT"

if [ -n "$SSH_KEY" ]; then
  if [ ! -f "$SSH_KEY" ]; then
    echo "SSH key not found: $SSH_KEY" >&2
    exit 1
  fi
  SSH+=(-i "$SSH_KEY")
  RSYNC_RSH+=" -i $SSH_KEY"
fi

echo "Target: $ORACLE_HOST"
echo "Remote home: $REMOTE_HOME"
echo "Mode: $SYNC_MODE"
echo "Dry run: $DRY_RUN"
echo

"${SSH[@]}" "$ORACLE_HOST" \
  "mkdir -p '$REMOTE_HOME/.agents/skills' '$REMOTE_HOME/.claude/skills' '$REMOTE_HOME/.codex/skills'"

declare -a MAP=(
  "$ROOT/agents/shared-skills:$REMOTE_HOME/.agents/skills"
  "$ROOT/agents/claude/skills:$REMOTE_HOME/.claude/skills"
  "$ROOT/agents/codex/skills:$REMOTE_HOME/.codex/skills"
)

sync_one() {
  local src="$1"
  local dst="$2"

  if [ ! -d "$src" ]; then
    echo "skip: $src"
    return
  fi

  local args=(-a --human-readable --itemize-changes)
  if [ "$SYNC_MODE" = "mirror" ]; then
    args+=(--delete)
  fi
  if [ "$DRY_RUN" = "1" ]; then
    args+=(--dry-run)
  fi

  args+=(
    --exclude='.git/'
    --exclude='node_modules/'
    --exclude='.env'
    --exclude='.env.*'
    --exclude='*.key'
    --exclude='*.pem'
    --exclude='*.token'
    --exclude='auth.json'
    --exclude='settings.json'
    --exclude='credentials*'
    --exclude='.system/'
  )

  echo "sync: $src -> $ORACLE_HOST:$dst"
  rsync "${args[@]}" -e "$RSYNC_RSH" "$src/" "$ORACLE_HOST:$dst/"
}

for item in "${MAP[@]}"; do
  src="${item%%:*}"
  dst="${item#*:}"
  sync_one "$src" "$dst"
done

if [ "$DRY_RUN" = "1" ]; then
  echo
  echo "Dry run complete. Re-run with DRY_RUN=0 to apply."
  exit 0
fi

echo
echo "Remote skill directories:"
"${SSH[@]}" "$ORACLE_HOST" "
  for d in \
    '$REMOTE_HOME/.agents/skills' \
    '$REMOTE_HOME/.claude/skills' \
    '$REMOTE_HOME/.codex/skills'
  do
    echo \"===== \$d =====\"
    find \"\$d\" -mindepth 1 -maxdepth 2 -name SKILL.md -print 2>/dev/null | sort || true
  done
"

echo
echo "Skill sync complete."
