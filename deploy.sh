#!/bin/bash
set -e

cd "$(dirname "$0")"

SERVICE_NAME="clash-master"
IMAGE="docker.io/foru17/clash-master:latest"

echo ">>> 1. Pulling latest image..."
podman pull "$IMAGE"

echo ">>> 2. Creating data directory..."
mkdir -p "$HOME/clash-master/data"

echo ">>> 3. Installing Quadlet service file..."
SYSTEMD_DIR="$HOME/.config/containers/systemd"
mkdir -p "$SYSTEMD_DIR"
cp "${SERVICE_NAME}.container" "$SYSTEMD_DIR/"

echo ">>> 4. Reloading systemd..."
systemctl --user daemon-reload

echo ">>> 5. Restarting service..."
systemctl --user restart "$SERVICE_NAME"

echo ">>> 6. Enabling User Linger..."
loginctl enable-linger "$USER" || echo "Warning: Could not enable linger."

echo ""
echo ">>> Deployment Complete! Checking status..."
systemctl --user status "$SERVICE_NAME" --no-pager
echo ""
echo ">>> Web UI:     http://$(hostname -I | awk '{print $1}'):3100"
echo ">>> API:        http://$(hostname -I | awk '{print $1}'):3101"
echo ">>> WebSocket:  ws://$(hostname -I | awk '{print $1}'):3102"