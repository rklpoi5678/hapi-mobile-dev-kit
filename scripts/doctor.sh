#!/usr/bin/env bash
set -u

version_or_missing() {
  local cmd="$1"
  shift

  if ! command -v "$cmd" >/dev/null 2>&1; then
    echo "missing"
    return
  fi

  "$cmd" "$@" 2>/dev/null | head -n 1 || command -v "$cmd"
}

printf '%-24s %s\n' "Architecture" "$(uname -m)"
printf '%-24s %s\n' "Kernel" "$(uname -sr)"
printf '%-24s %s\n' "Node" "$(node -v 2>/dev/null || echo missing)"
printf '%-24s %s\n' "npm" "$(npm -v 2>/dev/null || echo missing)"
printf '%-24s %s\n' "HAPI" "$(command -v hapi 2>/dev/null || echo missing)"
printf '%-24s %s\n' "Claude Code" "$(version_or_missing claude --version)"
printf '%-24s %s\n' "Codex" "$(version_or_missing codex --version)"
printf '%-24s %s\n' "OpenCode" "$(version_or_missing opencode --version)"
printf '%-24s %s\n' "Git" "$(git --version 2>/dev/null || echo missing)"
printf '%-24s %s\n' "Shared skills" "$HOME/.agents/skills"

echo
if command -v hapi >/dev/null 2>&1; then
  hapi doctor || true
fi

echo
systemctl --user --no-pager --full status hapi-hub.service 2>/dev/null || true
systemctl --user --no-pager --full status hapi-runner.service 2>/dev/null || true
