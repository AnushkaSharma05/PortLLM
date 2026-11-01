# PortLLM

Portable local AI chat for Windows, macOS, Linux, and Android. This fresh implementation uses a small Python standard-library gateway, a single-file browser client, and Ollama as the desktop inference engine. Chat history and settings are stored under `Shared/chat_data`.

## Requirements

- Python 3.9+
- [Ollama](https://ollama.com/download) on desktop, with a model pulled (for example `ollama pull llama3.2`)
- Modern browser

## Start

Run the matching launcher: `Windows/start-portllm.bat`, `Mac/start.command`, or `Linux/start.sh`. Open `http://localhost:3333` if the browser does not open. Android Termux: run `bash Android/install.sh` to build llama.cpp, add a `.gguf` file to `Shared/models`, then run `bash Android/start.sh`.

The server binds to localhost. Inference is local; an internet connection is only needed to install an engine or download model weights. Never expose the unauthenticated chat server directly to an untrusted network.

## Website

```sh
cd portllm-website
npm install
npm run dev
```

See `portllm-website/README.md` for production build commands.

## Data

Chat history and settings live in `Shared/chat_data`. Run the platform uninstall helper to remove those files. Model weights are kept in `Shared/models` and are not deleted by uninstall.
