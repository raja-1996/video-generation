#!/usr/bin/env bash
# Install Kokoro TTS in a uv venv, run a test synthesis and verify the WAV.
#
# Usage:  bash setup_kokoro.sh [target_dir]      (default: ./tts)
# Env:    SKIP_SYSTEM_DEPS=1  don't install espeak-ng via apt/brew
#         TORCH_GPU=1         on Linux, install the CUDA torch build instead of CPU-only
set -euo pipefail

TARGET_DIR="${1:-tts}"
PYTHON_VERSION="3.12"
SPACY_MODEL_URL="https://github.com/explosion/spacy-models/releases/download/en_core_web_sm-3.8.0/en_core_web_sm-3.8.0-py3-none-any.whl"
export UV_HTTP_TIMEOUT=300

log() { printf '\n\033[1;34m==> %s\033[0m\n' "$*"; }
die() { printf '\n\033[1;31mERROR: %s\033[0m\n' "$*" >&2; exit 1; }

OS="$(uname -s)"
ARCH="$(uname -m)"
log "Platform: $OS $ARCH"

# --- System deps (espeak-ng: fallback pronunciation for unknown words) ---
if [[ "${SKIP_SYSTEM_DEPS:-0}" != "1" ]]; then
  log "Installing system packages"
  if [[ "$OS" == "Linux" ]] && command -v apt-get >/dev/null; then
    SUDO=""; [[ "$(id -u)" -ne 0 ]] && SUDO="sudo"
    $SUDO apt-get update -y
    $SUDO apt-get install -y curl ca-certificates espeak-ng libsndfile1
  elif [[ "$OS" == "Linux" ]] && command -v dnf >/dev/null; then
    SUDO=""; [[ "$(id -u)" -ne 0 ]] && SUDO="sudo"
    $SUDO dnf install -y curl espeak-ng libsndfile
  elif [[ "$OS" == "Darwin" ]] && command -v brew >/dev/null; then
    brew list espeak-ng >/dev/null 2>&1 || brew install espeak-ng
  else
    echo "No supported package manager found; skipping espeak-ng (plain English still works)."
  fi
fi

# --- uv ---
if ! command -v uv >/dev/null; then
  log "Installing uv"
  curl -LsSf https://astral.sh/uv/install.sh | sh
  export PATH="$HOME/.local/bin:$PATH"
fi
command -v uv >/dev/null || die "uv not on PATH after install"
uv --version

# --- venv ---
mkdir -p "$TARGET_DIR"
cd "$TARGET_DIR"
# espeak-ng silently fails if its bundled data path exceeds 160 chars.
ESPEAK_DATA="$(pwd)/.venv/lib/python$PYTHON_VERSION/site-packages/espeakng_loader/espeak-ng-data"
(( ${#ESPEAK_DATA} < 160 )) || die "Target path too long for espeak-ng (${#ESPEAK_DATA} chars). Use a shorter target dir."
log "Creating venv in $(pwd)/.venv (Python $PYTHON_VERSION)"
uv venv --python "$PYTHON_VERSION" --allow-existing .venv

# --- Python packages ---
log "Installing Kokoro"
if [[ "$OS" == "Darwin" && "$ARCH" == "x86_64" ]]; then
  # Intel Mac: torch 2.2.2 is the last build with x86_64 macOS wheels,
  # and newer transformers/numpy don't work with it.
  uv pip install "torch==2.2.2" "transformers<4.50" "numpy<2" kokoro soundfile
elif [[ "$OS" == "Linux" && "${TORCH_GPU:-0}" != "1" ]]; then
  # CPU-only torch avoids multi-GB CUDA downloads on a VM without a GPU.
  uv pip install torch --index-url https://download.pytorch.org/whl/cpu
  uv pip install kokoro soundfile
else
  uv pip install kokoro soundfile
fi
# Pre-install the spaCy English model so the first run doesn't try to pip-install it.
uv pip install "$SPACY_MODEL_URL"

# --- Test script ---
cat > test_kokoro.py <<'PY'
import time

import numpy as np
import soundfile as sf
from kokoro import KPipeline

TEXT = "Hello! This is Kokoro, a small open-weight text to speech model, running locally."

start = time.time()
pipeline = KPipeline(lang_code="a", repo_id="hexgrad/Kokoro-82M")  # 'a' = American English
print(f"Pipeline loaded in {time.time() - start:.1f}s")

start = time.time()
chunks = [audio for _, _, audio in pipeline(TEXT, voice="af_heart")]
audio = np.concatenate(chunks)
elapsed = time.time() - start

sf.write("output.wav", audio, 24000)
print(f"Generated {len(audio) / 24000:.1f}s of audio in {elapsed:.1f}s -> output.wav")
PY

# --- Run test ---
log "Running test synthesis (first run downloads model weights)"
rm -f output.wav
.venv/bin/python test_kokoro.py

# --- Verify WAV ---
log "Verifying output.wav"
[[ -s output.wav ]] || die "output.wav was not created"
.venv/bin/python - <<'PY'
import sys
import soundfile as sf

info = sf.info("output.wav")
print(f"output.wav: {info.duration:.2f}s, {info.samplerate} Hz, {info.channels} ch")
if info.duration < 1.0:
    sys.exit("output.wav is too short; synthesis likely failed")
PY

log "Kokoro is installed and working: $(pwd)/output.wav"
