#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
COPY_MODE="${COPY_MODE:-merge}"  # merge | mirror
LOCAL_HOME="${LOCAL_HOME:-$HOME}"

declare -a SOURCES=(
  "$LOCAL_HOME/.agents/skills:$ROOT/agents/shared-skills"
  "$LOCAL_HOME/.claude/skills:$ROOT/agents/claude/skills"
  "$LOCAL_HOME/.codex/skills:$ROOT/agents/codex/skills"
)

command -v rsync >/dev/null 2>&1 || {
  echo "rsync is required." >&2
  exit 1
}

sync_one() {
  local src="$1"
  local dst="$2"

  mkdir -p "$dst"

  if [ ! -d "$src" ]; then
    echo "skip: $src (not found)"
    return
  fi

  local delete_flag=()
  if [ "$COPY_MODE" = "mirror" ]; then
    delete_flag=(--delete)
  fi

  echo "import: $src -> $dst"
  rsync -a "${delete_flag[@]}" \
    --exclude='.git/' \
    --exclude='node_modules/' \
    --exclude='.env' \
    --exclude='.env.*' \
    --exclude='*.key' \
    --exclude='*.pem' \
    --exclude='*.token' \
    --exclude='auth.json' \
    --exclude='settings.json' \
    --exclude='credentials*' \
    --exclude='.system/' \
    "$src/" "$dst/"
}

for item in "${SOURCES[@]}"; do
  src="${item%%:*}"
  dst="${item#*:}"
  sync_one "$src" "$dst"
done

echo
echo "Imported local skills into:"
echo "  $ROOT/agents/shared-skills"
echo "  $ROOT/agents/claude/skills"
echo "  $ROOT/agents/codex/skills"
echo
echo "Review with: git status && git diff"
