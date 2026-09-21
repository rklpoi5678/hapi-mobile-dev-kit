#!/usr/bin/env bash
set -euo pipefail

echo "== Fetch remotes =="
git fetch hapi-upstream --tags || true
git fetch opencode-upstream --tags || true

echo
echo "== HAPI latest commits =="
git log --oneline --decorate -5 hapi-upstream/main || true

echo
echo "== HAPI latest tags =="
git tag -l | tail -n 20 || true

echo
echo "Check upstream README / release notes manually:"
echo "  https://github.com/tiann/hapi"
echo "  https://opencode.ai/"