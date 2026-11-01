$root = Join-Path $PSScriptRoot '..\Shared'
Remove-Item (Join-Path $root 'chat_data'), (Join-Path $root 'logs') -Recurse -Force -ErrorAction SilentlyContinue
Write-Host 'PortLLM local history and logs removed.'
