#!/usr/bin/env bash
set -euo pipefail

npm install -g @twsxtd/hapi --registry=https://registry.npmjs.org
npm install -g opencode-ai

echo "HAPI: $(command -v hapi)"
hapi --help >/dev/null

echo "OpenCode: $(command -v opencode)"
opencode -v

echo
printf '%s\n' "Installed. Configure your provider credentials next, then run:" \
  "  hapi hub --relay" \
  "  hapi runner start --workspace-root \"$HOME/projects\""
