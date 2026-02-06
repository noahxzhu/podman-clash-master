#!/bin/bash
set -e

SERVICE_NAME="clash-master"
IMAGE="docker.io/foru17/clash-master:latest"
DATA_DIR="$HOME/clash-master"
SYSTEMD_DIR="$HOME/.config/containers/systemd"

echo ">>> 1. Stopping service..."
systemctl --user stop "$SERVICE_NAME" 2>/dev/null || true

echo ">>> 2. Removing Quadlet file..."
rm -f "$SYSTEMD_DIR/${SERVICE_NAME}.container"

echo ">>> 3. Reloading systemd..."
systemctl --user daemon-reload
systemctl --user reset-failed 2>/dev/null || true

echo ">>> 4. Removing container..."
podman rm -f "$SERVICE_NAME" 2>/dev/null || true

echo ">>> 5. Removing image..."
podman rmi "$IMAGE" 2>/dev/null || true

read -p ">>> 6. Delete data directory ($DATA_DIR)? [y/N] " confirm
if [[ "$confirm" =~ ^[Yy]$ ]]; then
    rm -rf "$DATA_DIR"
    echo "    Data deleted."
else
    echo "    Data kept."
fi

echo ""
echo ">>> Uninstall complete!"