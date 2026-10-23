#!/usr/bin/env bash
# ==============================================================================
# Local AI Hub Compose - Health Check & Port Inspection Script
# ==============================================================================

set -euo pipefail

NEW_API_PORT="${NEW_API_PORT:-3000}"
WORKBUDDY_PORT="${WORKBUDDY_PORT:-8788}"
TRAE_PORT="${TRAE_PORT:-8791}"
QODER_PORT="${QODER_PORT:-8790}"
CLIPROXY_PORT="${CLIPROXY_PORT:-8317}"

echo "=========================================="
echo " Local AI Hub - Checking Port Status"
echo "=========================================="

check_port() {
  local service_name="$1"
  local port="$2"
  if nc -z 127.0.0.1 "$port" 2>/dev/null || (echo > "/dev/tcp/127.0.0.1/$port") 2>/dev/null; then
    echo "[✓] $service_name is listening on port $port"
  else
    echo "[x] $service_name is NOT reachable on port $port"
  fi
}

check_port "New-API Gateway" "$NEW_API_PORT"
check_port "WorkBuddy Hub  " "$WORKBUDDY_PORT"
check_port "Trae Hub       " "$TRAE_PORT"
check_port "Qoder Hub      " "$QODER_PORT"
check_port "CLIProxyAPI    " "$CLIPROXY_PORT"

echo "=========================================="
echo " Inspection complete."
echo "=========================================="
