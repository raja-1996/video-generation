#!/usr/bin/env bash
# Make a render phone-ready: loudness to -14 LUFS (true peak -1 dB) and moov atom at the front.
# Usage: bash tools/finish.sh renders/name.mp4   -> renders/name-final.mp4
set -euo pipefail
IN="$1"; OUT="${IN%.mp4}-final.mp4"
ffmpeg -hide_banner -loglevel error -y -i "$IN" -c:v copy -af "loudnorm=I=-14:TP=-1.0:LRA=7" \
  -ar 48000 -ac 2 -c:a aac -b:a 192k -movflags +faststart "$OUT"
ffmpeg -hide_banner -i "$OUT" -vn -af "ebur128=framelog=quiet" -f null - 2>&1 | grep -E "^\s+I:" || true
echo "$OUT"
