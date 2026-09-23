#!/usr/bin/env bash
set -euo pipefail

WORKSPACE="${1:-$HOME/projects}"
HAPI_BIN="$(command -v hapi || true)"

if [ -z "$HAPI_BIN" ]; then
  echo "hapi not found. Run scripts/install-hapi-stack.sh first." >&2
  exit 1
fi

mkdir -p "$WORKSPACE" "$HOME/.config/systemd/user"
WORKSPACE="$(readlink -f "$WORKSPACE")"

cat > "$HOME/.config/systemd/user/hapi-hub.service" <<UNIT
[Unit]
Description=HAPI Hub
After=network-online.target
Wants=network-online.target

[Service]
Type=simple
Environment=PATH=$HOME/.local/bin:/usr/local/bin:/usr/bin:/bin
ExecStart=$HAPI_BIN hub --relay
Restart=always
RestartSec=5

[Install]
WantedBy=default.target
UNIT

cat > "$HOME/.config/systemd/user/hapi-runner.service" <<UNIT
[Unit]
Description=HAPI Runner
After=network-online.target hapi-hub.service
Wants=network-online.target

[Service]
Type=simple
KillMode=process
Environment=PATH=$HOME/.local/bin:/usr/local/bin:/usr/bin:/bin
Environment=HAPI_RUNNER_SUPERVISED=1
ExecStart=$HAPI_BIN runner start-sync --workspace-root $WORKSPACE
Restart=always
RestartSec=5

[Install]
WantedBy=default.target
UNIT

systemctl --user daemon-reload
systemctl --user enable --now hapi-hub.service hapi-runner.service

if command -v loginctl >/dev/null 2>&1; then
  echo "To keep user services alive after logout, run once:"
  echo "  sudo loginctl enable-linger $USER"
fi

echo "Workspace root: $WORKSPACE"
echo "Services enabled."
