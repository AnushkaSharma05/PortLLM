#!/data/data/com.termux/files/usr/bin/bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
pkg update -y
pkg install -y python termux-api cmake clang make git
mkdir -p "$ROOT/Shared/models" "$ROOT/Shared/bin" "$ROOT/Shared/build"
if [ ! -f "$ROOT/Shared/build/llama.cpp/CMakeLists.txt" ]; then
  git clone --depth 1 https://github.com/ggml-org/llama.cpp.git "$ROOT/Shared/build/llama.cpp"
fi
cmake -S "$ROOT/Shared/build/llama.cpp" -B "$ROOT/Shared/build/llama.cpp/build" -DCMAKE_BUILD_TYPE=Release -DGGML_OPENMP=OFF
cmake --build "$ROOT/Shared/build/llama.cpp/build" --target llama-server -j 2
cp "$ROOT/Shared/build/llama.cpp/build/bin/llama-server" "$ROOT/Shared/bin/llama-server"
echo 'PortLLM Android runtime built. Add a GGUF model to Shared/models, then run Android/start.sh.'
