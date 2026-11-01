#!/data/data/com.termux/files/usr/bin/bash
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
rm -rf "$ROOT/Shared/chat_data" "$ROOT/Shared/logs"
echo 'PortLLM history and logs removed.'
