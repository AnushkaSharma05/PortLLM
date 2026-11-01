#!/usr/bin/env bash
set -euo pipefail
# PortLLM's rebuilt client is self-contained and requires no vendor downloads.
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
mkdir -p "$ROOT/vendor"
printf 'The PortLLM client is self-contained; no UI assets need downloading.\n'
