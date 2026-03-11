#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CERTS_DIR="${SCRIPT_DIR}/certs"

if ! command -v mkcert >/dev/null 2>&1; then
  echo "→ Installing mkcert..."
  brew install mkcert
fi

echo "→ Installing local CA..."
mkcert -install

echo "→ Generating certificates..."
mkdir -p "${CERTS_DIR}"
mkcert -cert-file "${CERTS_DIR}/local.pem" \
       -key-file "${CERTS_DIR}/local-key.pem" \
       localhost local.dev 127.0.0.1 ::1

if ! grep -q "local.dev" /etc/hosts; then
  echo "→ Adding local.dev to /etc/hosts (requires sudo)..."
  echo "127.0.0.1 local.dev" | sudo tee -a /etc/hosts >/dev/null
else
  echo "→ local.dev already in /etc/hosts, skipping."
fi

echo ""
echo "Setup complete."
echo "  Run: make local-up"
echo "  Then visit: https://localhost or https://local.dev"
