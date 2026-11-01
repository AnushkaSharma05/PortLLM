$ErrorActionPreference = 'Stop'
if (-not (Get-Command python -ErrorAction SilentlyContinue)) { throw 'Python 3 is required.' }
if (-not (Get-Command ollama -ErrorAction SilentlyContinue)) { throw 'Install Ollama from https://ollama.com/download.' }
$root = Join-Path $PSScriptRoot '..\Shared'
New-Item (Join-Path $root 'models'), (Join-Path $root 'chat_data') -ItemType Directory -Force | Out-Null
Write-Host 'PortLLM is ready. Run start-portllm.bat.'
