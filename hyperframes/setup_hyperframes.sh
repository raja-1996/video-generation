#!/usr/bin/env bash
# Install HyperFrames (HTML -> video), create a test project, render it and verify the MP4.
#
# Usage:  bash setup_hyperframes.sh [project_dir]   (default: ./hf-test)
# Env:    SKIP_SYSTEM_DEPS=1  don't install Node/FFmpeg/Chrome libs via apt/brew
set -euo pipefail

PROJECT_DIR="${1:-hf-test}"
NODE_MAJOR=22
export HYPERFRAMES_NO_TELEMETRY=1

log() { printf '\n\033[1;34m==> %s\033[0m\n' "$*"; }
die() { printf '\n\033[1;31mERROR: %s\033[0m\n' "$*" >&2; exit 1; }

OS="$(uname -s)"
log "Platform: $OS $(uname -m)"
node_ok() { command -v node >/dev/null && (( $(node -p 'process.versions.node.split(".")[0]') >= NODE_MAJOR )); }

# --- System deps: Node >= 22, FFmpeg, headless Chrome libs ---
if [[ "${SKIP_SYSTEM_DEPS:-0}" != "1" ]]; then
  log "Installing system packages"
  if [[ "$OS" == "Linux" ]] && command -v apt-get >/dev/null; then
    SUDO=""; [[ "$(id -u)" -ne 0 ]] && SUDO="sudo"
    $SUDO apt-get update -y
    $SUDO apt-get install -y curl ca-certificates ffmpeg fonts-liberation \
      libnss3 libatk-bridge2.0-0 libgbm1 libxkbcommon0 libxcomposite1 libxdamage1 \
      libxrandr2 libpango-1.0-0 libcups2 libdrm2
    $SUDO apt-get install -y libasound2t64 2>/dev/null || $SUDO apt-get install -y libasound2
    if ! node_ok; then
      curl -fsSL "https://deb.nodesource.com/setup_${NODE_MAJOR}.x" | $SUDO -E bash -
      $SUDO apt-get install -y nodejs
    fi
  elif [[ "$OS" == "Darwin" ]] && command -v brew >/dev/null; then
    command -v ffmpeg >/dev/null || brew install ffmpeg
    node_ok || { brew install "node@${NODE_MAJOR}"; export PATH="$(brew --prefix "node@${NODE_MAJOR}")/bin:$PATH"; }
  else
    echo "No supported package manager found; install Node ${NODE_MAJOR}+ and FFmpeg yourself."
  fi
fi

node_ok || die "Node ${NODE_MAJOR}+ is required (found: $(node --version 2>/dev/null || echo none))"
command -v ffmpeg >/dev/null || die "FFmpeg is required"
log "Node $(node --version), $(ffmpeg -version | head -1)"

# --- HyperFrames CLI ---
HF=(npx --yes hyperframes@latest)
log "Ensuring Chrome for HyperFrames"
"${HF[@]}" browser ensure

# --- Test project ---
log "Creating project $PROJECT_DIR"
[[ -e "$PROJECT_DIR" ]] && die "$PROJECT_DIR already exists; pass a new project dir"
"${HF[@]}" init "$PROJECT_DIR" --non-interactive
cd "$PROJECT_DIR"

log "Running doctor"
"${HF[@]}" doctor || echo "(doctor reported issues; continuing to render)"

# --- Render ---
log "Rendering output.mp4"
rm -f output.mp4
"${HF[@]}" render -o output.mp4 --quality draft

# --- Verify MP4 ---
log "Verifying output.mp4"
[[ -s output.mp4 ]] || die "output.mp4 was not created"
DURATION="$(ffprobe -v error -show_entries format=duration -of csv=p=0 output.mp4)"
VIDEO="$(ffprobe -v error -select_streams v:0 -show_entries stream=codec_name,width,height -of csv=p=0 output.mp4)"
[[ -n "$VIDEO" ]] || die "output.mp4 has no video stream"
echo "output.mp4: ${DURATION}s, video ${VIDEO}"
awk "BEGIN { exit !($DURATION > 0.5) }" || die "output.mp4 is too short"

log "HyperFrames is installed and working: $(pwd)/output.mp4"
