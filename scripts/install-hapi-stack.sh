#!/usr/bin/env bash
set -euo pipefail

NPM_PREFIX="$HOME/.local"

mkdir -p "$NPM_PREFIX"
npm config set prefix "$NPM_PREFIX"

export PATH="$NPM_PREFIX/bin:$PATH"

if ! grep -q 'HOME/.local/bin' "$HOME/.profile" 2>/dev/null; then
  echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.profile"
fi

echo "Installing HAPI..."
npm install -g @twsxtd/hapi --registry=https://registry.npmjs.org

echo "Installing OpenCode..."
npm install -g opencode-ai

echo
echo "Checking installation..."

command -v hapi
hapi --help >/dev/null

command -v opencode
opencode --version

echo
echo "Installation complete."
echo
echo "Next:"
echo "  hapi hub --relay"
echo "  hapi runner start --workspace-root \"$HOME/projects\""