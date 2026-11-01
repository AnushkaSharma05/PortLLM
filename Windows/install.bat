@echo off
where python >nul 2>nul || (echo Python 3 is required. Install it from python.org & pause & exit /b 1)
if not exist "%ProgramFiles%\Ollama\ollama.exe" where ollama >nul 2>nul || (echo Install Ollama from https://ollama.com/download & pause & exit /b 1)
if not exist "%~dp0..\Shared\models" mkdir "%~dp0..\Shared\models"
if not exist "%~dp0..\Shared\chat_data" mkdir "%~dp0..\Shared\chat_data"
echo PortLLM is ready. Run start-portllm.bat.
pause
