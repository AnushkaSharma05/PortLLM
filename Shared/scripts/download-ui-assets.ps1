$ErrorActionPreference = 'Stop'
$vendor = Join-Path (Split-Path $PSScriptRoot -Parent) 'vendor'
New-Item -ItemType Directory -Force -Path $vendor | Out-Null
Write-Host 'The PortLLM client is self-contained; no UI assets need downloading.'
