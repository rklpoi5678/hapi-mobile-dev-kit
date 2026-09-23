#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

"$ROOT/scripts/import-local-skills.sh"

echo
echo "Imported local skills. Starting Oracle sync..."
"$ROOT/scripts/sync-skills-to-oracle.sh"
