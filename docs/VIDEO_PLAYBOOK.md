# Video playbook: turning a paper into a narrated explainer

How we make explainer videos in this repo, worked out while building the DCN-V2 video
(`dcn-v2-explainer/`). Read this before starting a new one. The visual system is in [DESIGN.md](DESIGN.md).

## The owner's principles

These come from the requests that shaped the DCN-V2 video. They take priority over defaults.

1. **One connected story.** The video follows one person through one situation from start to end
   (Maya opens an app in Madrid at 11 pm). Every concept is a step in serving her request. No tour of facts.
2. **Math never sounds like math.** Every formula is first a real-world process the viewer already knows
   (a shopkeeper's hunch, switches and a bulb, a mixing desk, a notebook lookup). The symbols appear only
   afterwards, with each term underlined and named in plain words ("combine", "listen", "keep").
3. **Explain the math in detail, with real numbers.** When a step matters, work it through with numbers the
   viewer can check (`0.1·M + 2·E` → `2·M·E` is 2 when both are true, 0 when not; −log 0.9 = 0.11).
   Example values are labelled as examples.
4. **Intuition plus the real problem it solves.** Say why the idea exists (hand-written rules explode;
   big networks are slow and bad at multiplying) before showing how it works.
5. **Voice only.** Narration carries the film. No music, no sound effects (owner's preference).
6. **Length follows the content.** A first cut of about 3 minutes; the owner then asked for 5 minutes, then for
   more math detail (8 minutes). Add scenes for missing ideas rather than stretching existing ones.
7. **Stay true to the source.** Every claim and number traces to the paper. When the story would bend a fact,
   fix the story (two cross layers make *trios*, so the script says "Madrid, and English, and 11 pm").
   Illustrative values are marked on screen.

## Workflow

Everything below runs in `dcn-v2-explainer/`; copy that folder to start a new film.

| Step | What | Command / file |
| --- | --- | --- |
| 0 | Install tools once per machine/container | `bash kokoro/setup_kokoro.sh tts` and `bash hyperframes/setup_hyperframes.sh` |
| 1 | Read the whole source; list its claims and numbers | `pdftotext paper.pdf` |
| 2 | Propose three storylines (different worlds, devices, forms); the owner picks | `STORYLINES.md` |
| 3 | Write the spec: look, motion, banned defaults | `SPEC.md` |
| 4 | Write the narration as scenes of short lines (each line is a cue point) | `script.json` |
| 5 | Generate the voice and the timing | `../tts/.venv/bin/python tools/tts.py .` → `assets/narration.wav`, `timing.json` |
| 6 | Encode the voice for the page | `ffmpeg -i assets/narration.wav -b:a 160k assets/narration.mp3` |
| 7 | One HTML scene per narration scene, reveals cued to that scene's line times | `compositions/<id>.html` |
| 8 | Mount every scene and the voice | `node tools/build-index.mjs` → `index.html` |
| 9 | Check, then look | `npx hyperframes check --json`; `npx hyperframes snapshot --at <t,...>` |
| 10 | Render | `npx hyperframes render -o renders/<name>.mp4 --quality high` |
| 11 | Make it loud enough for phones | `bash tools/finish.sh renders/<name>.mp4` (−14 LUFS, faststart) |

### Narration rules

- Kokoro voice `af_heart`, American English, speed 1.0. About 2.4 words per second.
- Lines of 6–20 words. Each line is a cue: the picture changes on the line that names it.
- Spell numbers the way they should be spoken ("zero point six percent", "eleven p.m.").
- `tools/tts.py` pads 0.45 s before each scene, 0.32 s between lines, 0.75 s after; `timing.json` records
  every scene's start and every line's local start. Scenes tile the voice with no gaps.
- Adding scenes later only shifts start times; existing scenes keep their internal cues, so they need no edits.

### Scene rules

- A scene reveals its parts on the spoken line, across the scene, never all at once in the first second.
- Something changes every 2–4 s; a deliberate final hold carries `data-hold`.
- Text meant to be read is at least 28 px and stays up 0.5 s + 0.3 s per word.
- Never repeat the spoken sentence on screen word for word; on-screen text names things, the voice explains.

## Gotchas we hit

- **3D card flips** (`backface-visibility`) render mirrored in the headless renderer. Flip by squashing
  `scaleX` to 0, swapping faces, and growing back.
- **SVG rotations**: set each element's `svgOrigin` in its own `tl.set`; sharing one `set` across elements
  bakes the first origin into both.
- **Dead-stretch false alarms**: `check` does not see SVG stroke draw-ons; confirm with a snapshot range and
  mark the element `data-hold`.
- **Red text on kraft** fails contrast at the bright red; the accent is `#b52a1f`.
- **Render time** is about 2.5× the video length on this cloud container (8 min video ≈ 19 min). Kokoro
  slows down a lot while a render is running; generate the voice first.
- **Quiet audio on phones**: raw Kokoro narration lands near −23 LUFS. Always run `tools/finish.sh`.
  The Claude mobile app's in-chat player may still play silently; download the file to check.
- **Do not commit media**: `*.mp4`, `*.wav`, and the narration `*.mp3` are ignored. Regenerate audio from
  `script.json` with step 5–6.
