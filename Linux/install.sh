#!/usr/bin/env bash
set -euo pipefail
command -v python3 >/dev/null || { echo 'Install Python 3 first.' >&2; exit 1; }
if ! command -v ollama >/dev/null; then echo 'Install Ollama from https://ollama.com/download'; exit 1; fi
mkdir -p "$(dirname "$0")/../Shared/models" "$(dirname "$0")/../Shared/chat_data"
echo 'PortLLM is ready. Run Linux/start.sh to launch.'
