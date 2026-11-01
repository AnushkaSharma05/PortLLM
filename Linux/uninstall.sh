#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
rm -rf "$ROOT/Shared/chat_data" "$ROOT/Shared/logs"
echo 'PortLLM local chat history and logs removed.'
