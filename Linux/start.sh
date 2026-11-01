#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
command -v python3 >/dev/null || { echo 'Python 3 is required.' >&2; exit 1; }
command -v ollama >/dev/null || { echo 'Ollama is required. Install it, then run ollama serve.' >&2; exit 1; }
ollama serve >/dev/null 2>&1 & ENGINE_PID=$!
cleanup(){ kill "$ENGINE_PID" 2>/dev/null || true; }
trap cleanup EXIT
sleep 2
python3 "$ROOT/Shared/chat_server.py"
