#!/usr/bin/env bash
set -euo pipefail

if ! command -v apt-get >/dev/null 2>&1; then
  echo "This bootstrap script targets Ubuntu/Debian (apt-get required)." >&2
  exit 1
fi

sudo apt-get update
sudo apt-get install -y git curl ca-certificates build-essential jq rsync

if command -v node >/dev/null 2>&1; then
  major="$(node -p 'process.versions.node.split(`.`)[0]')"
else
  major=0
fi

if [ "$major" -lt 18 ]; then
  echo "Installing Node.js 22.x from NodeSource..."
  curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash -
  sudo apt-get install -y nodejs
fi

node -v
npm -v
