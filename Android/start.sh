#!/data/data/com.termux/files/usr/bin/bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
export PORTLLM_ENGINE=llama
export PORTLLM_ENGINE_URL="http://127.0.0.1:8080"
MODEL="${1:-$(find "$ROOT/Shared/models" -name '*.gguf' -print -quit)}"
[ -x "$ROOT/Shared/bin/llama-server" ] || { echo 'Build or place llama-server in Shared/bin first.' >&2; exit 1; }
[ -n "$MODEL" ] || { echo 'Place a .gguf model in Shared/models or pass a model path.' >&2; exit 1; }
"$ROOT/Shared/bin/llama-server" -m "$MODEL" --host 127.0.0.1 --port 8080 &
ENGINE_PID=$!
trap 'kill "$ENGINE_PID" 2>/dev/null || true' EXIT
sleep 2
python "$ROOT/Shared/chat_server.py"
