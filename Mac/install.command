#!/bin/bash
set -e
command -v python3 >/dev/null || { echo 'Install Python 3 first.'; read -r; exit 1; }
command -v ollama >/dev/null || { echo 'Install Ollama from https://ollama.com/download'; read -r; exit 1; }
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
mkdir -p "$ROOT/Shared/models" "$ROOT/Shared/chat_data"
echo 'PortLLM is ready. Run Mac/start.command.'
