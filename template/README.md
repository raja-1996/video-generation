# Template tools

Copied into each new video project by the `paper-to-video` skill (`.claude/skills/paper-to-video/SKILL.md`).

| File | What |
| --- | --- |
| `tools/tts.py` | `script.json` → `assets/narration.wav` + `timing.json` (Kokoro, voice from the script) |
| `tools/build-index.mjs` | `timing.json` + `compositions/*.html` → `index.html` (one host per scene, the narration track, shared styles) |
| `tools/shared.css` | the design tokens and shared classes (tags, stamps, kraft ground, equation labels) |
| `tools/render.mjs` | renders `index.html` with the fastest settings for this machine (GPU if present, workers from the cores) |
| `tools/finish.sh` | render → phone-ready MP4 (−14 LUFS, faststart) |
