---
name: paper-to-video
description: Turn a research paper (an arXiv or PDF link, or a pasted paper) into a narrated explainer video in this repo's style. Use whenever the owner shares a paper link or asks for a video explaining a paper.
---

# Paper → narrated explainer video

The owner's principles and the full workflow are in `docs/VIDEO_PLAYBOOK.md`; the visual system is in
`docs/DESIGN.md`. Read both first, and load the `hyperframes` skill before writing scenes.
`dcn-v2-explainer/` is the reference film: copy its patterns (scene files, cue timing, equation labels).

**One film per paper.** Since 2026-10-30 each paper gets a single film covering how and why, built in
`videos/<slug>-film/` by the scene order in `FILM.md` (this folder). `FILM.md` sets the scenes, length and
commands; the steps below set up, read the paper, pick the story and deliver. The old pair (a how film in
`<slug>-explainer` and a why film in `<slug>-why`, from `WHY.md`) is deprecated: don't build new ones.

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
look. Each storyline must also carry the 3 symptom rows and a ladder of earlier approaches (`FILM.md`
scenes 2–3). Put your recommendation first with a one-line reason and save them to `STORYLINES.md`, marking it
picked (line 1 format in `FILM.md`). Do not ask the owner to pick: build the recommended storyline straight
through to the render. In one line, say which storyline you picked and why, the planned length (about 10
minutes), and that narration is Kokoro voice-only. The owner can still ask for B or C after seeing the film.

## 4. Build

```bash
SLUG=<short-name>-film                 # e.g. autoint-film
npx hyperframes init videos/$SLUG --non-interactive
cp -r template/tools videos/$SLUG/ && mkdir -p videos/$SLUG/{assets,compositions}
printf '.hyperframes/\nrenders/\n*.wav\nassets/*.mp3\n' > videos/$SLUG/.gitignore
```

1. `SPEC.md` (look, motion, banned list; reuse DESIGN.md unless the storyline calls for another world).
2. `script.json`: one scene per `FILM.md` scene (split a long one if needed), short lines, each line a cue.
   Math scenes follow the pattern: real-world process
   first → symbols with every term named in plain words → worked with real numbers (exact arithmetic,
   example weights labelled). Check every sentence against the paper.
3. Voice: `../../tts/.venv/bin/python tools/tts.py .` then
   `ffmpeg -y -i assets/narration.wav -b:a 160k assets/narration.mp3`. Read `timing.json` for line cues.
4. One `compositions/<id>.html` per scene, reveals on the line that names them. `node tools/build-index.mjs`.
5. `npx hyperframes check --json`: fix every error; fix or `data-hold` every dead stretch.
6. Snapshot every scene's last frame (`npx hyperframes snapshot --at <start+dur-0.35,...>`) and look at
   them: overlaps, clipped text, labels on curves, anything a stranger would not understand. Fix, re-check.

## 5. Deliver

- Render, finish and share copy exactly as in `FILM.md` → Commands, all in the foreground. Generate all voice
  before rendering; Kokoro is slow while a render runs.
- Verify with ffprobe that `renders/$SLUG-final.mp4` has audio, then send it with SendUserFile.
- Write `REVIEW.md` (choices, what is illustrative, weakest shot) and `INTERVIEW.md`.
- Put it in the library: create `../library/<topic>/<slug>/` with the PDF if missing, then run
  `node library/build-gallery.mjs` from `paper/`.
- Never commit or push the films or the `videos/` folders; they stay local.

## 6. Deprecated: the two-film pair

Until 2026-10-30 each paper got a how film (`videos/<slug>-explainer/`) and a why film (`videos/<slug>-why/`,
spec in `WHY.md`). Both are replaced by the one film in `FILM.md`. Keep the existing pairs as they are; don't
build new ones or rebuild old ones unless the owner asks.
