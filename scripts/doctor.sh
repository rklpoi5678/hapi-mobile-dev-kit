#!/usr/bin/env bash
set -u

printf '%-24s %s\n' "Architecture" "$(uname -m)"
printf '%-24s %s\n' "Kernel" "$(uname -sr)"
printf '%-24s %s\n' "Node" "$(node -v 2>/dev/null || echo missing)"
printf '%-24s %s\n' "npm" "$(npm -v 2>/dev/null || echo missing)"
printf '%-24s %s\n' "HAPI" "$(command -v hapi 2>/dev/null || echo missing)"
printf '%-24s %s\n' "OpenCode" "$(command -v opencode 2>/dev/null || echo missing)"
printf '%-24s %s\n' "Git" "$(git --version 2>/dev/null || echo missing)"

echo
if command -v hapi >/dev/null 2>&1; then
  hapi doctor || true
fi

echo
systemctl --user --no-pager --full status hapi-hub.service 2>/dev/null || true
systemctl --user --no-pager --full status hapi-runner.service 2>/dev/null || true
