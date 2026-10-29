---
name: paper-to-video
description: Turn a research paper (an arXiv or PDF link, or a pasted paper) into a narrated explainer video in this repo's style. Use whenever the owner shares a paper link or asks for a video explaining a paper.
---

# Paper → narrated explainer video

The owner's principles and the full workflow are in `docs/VIDEO_PLAYBOOK.md`; the visual system is in
`docs/DESIGN.md`. Read both first, and load the `hyperframes` skill before writing scenes.
`dcn-v2-explainer/` is the reference film: copy its patterns (scene files, cue timing, equation labels).

## 1. Setup (only if missing)

```bash
[ -x tts/.venv/bin/python ] || bash kokoro/setup_kokoro.sh tts            # ~1.5 min
npx --yes hyperframes@latest doctor >/dev/null 2>&1 || bash hyperframes/setup_hyperframes.sh hf-test
```

## 2. Read the paper

- Download into the scratchpad (`curl -sSL -o paper.pdf <link>`, arXiv `abs/` links become `pdf/`), then
  `pdftotext paper.pdf`. Read all of it, including the experiments and any production section.
- Write down: the problem it solves, the core mechanism and its equations, every headline number with its
  table or section, and what is only illustrative.

## 3. Three storylines, then go with the recommended one (no stop)

Write three storylines that are different films (`hyperframes` skill, `references/story.md`): each with a
person in a concrete situation, a device that makes the math physical, its first two seconds, its beats, its
look. Put your recommendation first with a one-line reason and save them to `STORYLINES.md`, marking it picked
(line 1: `# Storylines (picked: A) — ...`). Do not ask the owner to pick: build the recommended storyline
straight through to the render. In one line, say which storyline you picked and why, the planned length (about
3 minutes for a first cut), and that narration is Kokoro voice-only. The owner can still ask for B or C after
seeing the film.

## 4. Build

```bash
SLUG=<short-name>                      # e.g. attention-explainer
npx hyperframes init videos/$SLUG --non-interactive
cp -r template/tools videos/$SLUG/ && mkdir -p videos/$SLUG/{assets,compositions}
printf '.hyperframes/\nrenders/\n*.wav\nassets/*.mp3\n' > videos/$SLUG/.gitignore
```

1. `SPEC.md` (look, motion, banned list; reuse DESIGN.md unless the storyline calls for another world).
2. `script.json`: scenes of short lines, each line a cue. Math scenes follow the pattern: real-world process
   first → symbols with every term named in plain words → worked with real numbers (exact arithmetic,
   example weights labelled). Check every sentence against the paper.
3. Voice: `../../tts/.venv/bin/python tools/tts.py .` then
   `ffmpeg -y -i assets/narration.wav -b:a 160k assets/narration.mp3`. Read `timing.json` for line cues.
4. One `compositions/<id>.html` per scene, reveals on the line that names them. `node tools/build-index.mjs`.
5. `npx hyperframes check --json`: fix every error; fix or `data-hold` every dead stretch.
6. Snapshot every scene's last frame (`npx hyperframes snapshot --at <start+dur-0.35,...>`) and look at
   them: overlaps, clipped text, labels on curves, anything a stranger would not understand. Fix, re-check.

## 5. Deliver

- Render: `npx hyperframes render -o renders/$SLUG.mp4 --quality high` in the background (about 2.5× the
  video length). Generate all voice before rendering; Kokoro is slow while a render runs.
- `bash tools/finish.sh renders/$SLUG.mp4` (−14 LUFS, faststart), verify with ffprobe that it has audio,
  then send `renders/$SLUG-final.mp4` with SendUserFile.
- Write `REVIEW.md` (choices, what is illustrative, weakest shot). Commit the source only, never media,
  and push to the working branch.
- Offer the next steps the owner has asked for before: a longer cut, more worked math.

## 6. The "why" film (second film per paper)

When the owner asks for the deep dive, meaning why the method works, 5 whys, the math, or interview questions,
follow `WHY.md` in this folder. It builds `videos/<slug>-why/` plus `INTERVIEW.md` from the paper's explainer.
