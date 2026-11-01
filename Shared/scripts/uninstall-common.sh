#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
rm -rf "$ROOT/chat_data" "$ROOT/logs"
echo 'Local history and logs removed.'
