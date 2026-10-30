# The film: one video per paper

Each paper gets **one** film: how the method works and why it works, in a single connected story.
It replaced the earlier pair (`<slug>-explainer` how film + `<slug>-why` deep dive) on 2026-10-30. The owner
locked the outline below. The old pair is deprecated: don't build new ones, and leave the existing ones alone.

The project is `videos/<slug>-film/`. Build it end to end without stopping for questions.

**Pilot: `videos/autoint-film/`** (approved 2026-10-30, 10:28, 18 scenes). Open it first and copy its structure,
tooling and look: STORYLINES.md, SPEC.md, script.json, compositions/*.html, INTERVIEW.md, REVIEW.md. The pilot is
the template, not the content. Two things in it to reuse:
- `tools/make-rungs.py` writes all ladder scenes from one layout (formula, the 3 rows with this rung's
  predictions, its limit, a real-data chip, and a ladder sidebar). Copy it and change only the `SPEC` dict.
- Fitting the cap: it split the ladder into one scene per rung, folded heads and headline results into the proof
  scene, and made the close the last line of "what came next". Do the same when a film runs long.

If the paper already has an old explainer or why film, reuse its person, story world and scenes; that is what
kept the pilot to about 19 minutes.

## Scene order (~10 min)
Timings are targets, not measured values.

1. **Opening** (20 s): the person, the moment, and the card of facts the model sees.
2. **Symptom** (30 s): 3 example rows, each with its right answer. The same 3 rows are carried through the whole
   film.
3. **Ladder, simple to advanced** (2.5 min): 4–5 earlier approaches in order, ending one step before the paper.
   For each rung:
   - say what it does in one line;
   - show its prediction on the 3 rows and which row it gets wrong;
   - give its limit in one line, which sets up the next rung.

   Take rungs from the paper's own baselines and related work first. Label any rung the paper does not compare
   against "our reading".
4. **Root cause and hidden assumption** (30 s): what every rung has in common, and the one belief that real data
   breaks.
5. **Key idea** (20 s): the paper's one change, which is the last rung of the ladder.
6. **Mechanism walkthrough** (2 min): the step-by-step device (round table, clerk, shopkeeper). Show the parts
   such as heads, residual and stacking inside the device.
7. **Math** (90 s):
   - Show the paper's key equations and name every symbol in words.
   - Show what the loss and gradient (or the training signal) push the parameters toward, and why that removes
     the root cause.
   - Follow the usual order: real-world process, then symbols, then worked numbers.
8. **Replay** (45 s): run the 3 rows through the new method with example numbers, carrying the numbers through.
   All 3 come out right.
9. **Results and proof** (60 s): headline numbers, plus the ablation, case study or analysis that isolates the
   idea. If the paper has no ablation, say so on screen.
10. **Cost and limits** (30 s): parameters, latency, data needs, failure cases, and when not to use it.
11. **What came next and close** (45 s):
    - **Backward**: which earlier paper's limit this one fixes. This usually closes the ladder.
    - **Forward**: the 2–4 most important papers that built on it, drawn from the whole field and not only the
      library. Give each one line on what it changed, plus its year and venue.
    - Tag each paper on screen **in library** (it has a folder under `../library/`) or **not yet filmed**.
    - Label a lineage claim "our reading" unless the citing paper states it.
    - Cite only papers you are sure exist. Check any title, year or venue you are unsure of against arXiv
      before it goes on screen.
    - End back with the person.
12. **Interview drill** (60 s): 5 cards (concept, math, trade-off, production, debugging), each with a spoken
    answer of 1–2 sentences. Put a small diagram or the key formula in each card's lower half so no card is half
    empty.

## INTERVIEW.md
- 12–15 questions, grouped as: concept, math/derivation, comparison, design trade-offs, production/serving,
  debugging/failure, extensions.
- Each has a 2–5 line answer that cites the paper (section, table or equation) or is marked **our reading**.
- Each has one "Follow-up:" an interviewer might ask next.
- End with a **Read next** list of the scene 11 papers that are not yet in the library: title, year, venue and
  arXiv id. These are candidates to fetch next.
- Use the same format as `videos/ffm-why/INTERVIEW.md`.

## Rules
- One connected story with one person in it, from the opening to the close.
- Facts trace to the paper. Label example values "example", call redrawn figures "a sketch of Figure N", and
  label anything not in the paper "our reading" on screen.
- Narration only (Kokoro af_heart), no music. Text at least 28 px.
- **Length about 10 minutes, hard cap 10:30.** If the timing comes out longer, trim before rendering. Cut the
  ladder to 4 rungs first, then shorten the mechanism.
- HyperFrames contract:
  - Each composition is a `<template>` with `#root` and registers a paused GSAP timeline in
    `window.__timelines[id]`.
  - No CSS transform on elements GSAP animates.
  - No `Math.random`, and no stagger from "random".
  - Draw SVG strokes with `pathLength="1"` plus `strokeDashoffset`.
  - Mark deliberate stills with `data-hold`.
- STORYLINES.md line 1:
  `# Storylines (picked: A) — "<full paper title>" (<authors short>, <venue year>)`. The library gallery reads
  the title and source from this line.
  Also write SPEC.md, script.json, timing.json and REVIEW.md.

## Commands
Prefix every command with `export PATH=/usr/local/bin:$PATH HYPERFRAMES_NO_TELEMETRY=1`, and run it from
`videos/<slug>-film`. Run hyperframes only in your own folder.
- TTS: `../../tts/.venv/bin/python tools/tts.py .` then `ffmpeg -y -i assets/narration.wav -b:a 160k assets/narration.mp3`
- `node tools/build-index.mjs`
- `npx --yes hyperframes@0.8.210 check` must report 0 errors.
- `npx --yes hyperframes@0.8.210 snapshot --at ...`: check the frames for overlaps and clipping, especially in
  the ladder, equation and table scenes, and check that no table header is duplicated.
- `npx --yes hyperframes@0.8.210 render -o renders/<slug>-film.mp4 --quality high`
- `bash tools/finish.sh renders/<slug>-film.mp4` writes `<slug>-film-final.mp4`.
- Share copy: `ffmpeg -y -i renders/<slug>-film-final.mp4 -c:v libx264 -crf 26 -preset fast -c:a copy -movflags +faststart renders/<slug>-film-share.mp4`.
  It must be under 30 MB; if it isn't, raise crf.
- Library: create `../library/<topic>/<slug>/` with `<slug>.pdf` if missing, then run
  `node ../library/build-gallery.mjs` from the `paper/` folder. It copies the final render in as `<slug>.mp4`.

**Speed:** run TTS, check, render, finish.sh and the share copy in the **foreground** (a Bash timeout of
600000 ms), never in the background. A 10-minute film renders in about 5–6 minutes. Scene writing is the slow
step, so plan the scenes from script.json before you write them.

**Scrambled tables:** if a table in the pdftotext output is jumbled, re-extract it with the layout kept:
`pdftotext -layout paper.pdf - | grep -n -A15 "Table N"`.

## Verify before delivering
- Recompute every worked number in Python, including every ladder rung's prediction on the 3 rows.
- Spoken numbers must match on-screen numbers.
- Check every paper number against the paper text. Papers have typos (for example, RankMixer's Table 6 prints
  20.7× where 2106 ÷ 107 = 19.7×). Flag these on screen or in INTERVIEW.md, don't copy them.
- Never commit or push the films or the `videos/` folders; they stay local.

## Report
Give the duration, a one-line scene list, the check result, the paths to the final and share mp4 and to
INTERVIEW.md, everything labelled "our reading", and any claims or citations you were unsure of.
