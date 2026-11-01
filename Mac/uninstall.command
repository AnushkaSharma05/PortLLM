#!/bin/bash
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
rm -rf "$ROOT/Shared/chat_data" "$ROOT/Shared/logs"
echo 'Local chat history and logs removed.'
