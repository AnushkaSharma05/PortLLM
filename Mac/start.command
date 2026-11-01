#!/bin/bash
set -e
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
command -v python3 >/dev/null || { echo 'Python 3 is required.'; read -r; exit 1; }
command -v ollama >/dev/null || { echo 'Install Ollama from ollama.com/download.'; read -r; exit 1; }
ollama serve >/dev/null 2>&1 & PID=$!
trap 'kill "$PID" 2>/dev/null || true' EXIT
sleep 2
python3 "$ROOT/Shared/chat_server.py"
