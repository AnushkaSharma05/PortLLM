@echo off
setlocal
set "ROOT=%~dp0.."
where python >nul 2>nul || (echo Python 3 is required.& pause & exit /b 1)
start "PortLLM Ollama" /min ollama serve
 timeout /t 2 /nobreak >nul
python "%ROOT%\Shared\chat_server.py"
pause
