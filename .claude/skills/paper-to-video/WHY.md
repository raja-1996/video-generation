# The "why" film: a deep dive on one paper

The second film for a paper, made after its explainer (`videos/<slug>-explainer/`). The explainer shows *how* the
method works. The why film goes down to the root cause, the way an RCA's 5 whys does:
- why the old approach fails;
- why this mechanism fixes it, with the math;
- why simpler fixes fall short;
- what it costs.

It ends with an interview drill and an `INTERVIEW.md`.

The owner approved this format from the pilot `videos/ffm-why/`. Open it first and copy its structure, tooling and
look: STORYLINES.md, SPEC.md, script.json, compositions/*.html, tools/, INTERVIEW.md, REVIEW.md. The pilot is the
template, not the content.

Reuse the explainer's character, story world and look so the two films feel like a set. The new project is
`videos/<slug>-why/`. Build it end to end without stopping for questions: pick the recommended option
everywhere, since the format is already approved. Steps 1–2 of `SKILL.md` (setup, read the paper) still apply.

## The why-ladder (scene order)
1. **Symptom**: 2–3 example rows where the baseline the paper beats gives a bad prediction or a bad outcome.
2. **Root cause by 5 whys**: keep asking why until you reach a structural limit of the old approach, not "it
   scored lower".
3. **Hidden assumption**: the belief built into the old approach that real data breaks.
4. **Key idea**: the one change that removes the root cause.
5. **Why the mechanism works, with the math**:
   - Show the paper's key equations and name every symbol in words.
   - Show what the loss and gradient (or the training signal) push the parameters toward, and why that fixes
     the root cause.
   - Work it through with small labelled example numbers: before vs after one step, or old vs new on the same
     inputs.
   - Every formula follows the usual order: real-world process, then symbols, then worked numbers.
6. **Replay**: run the step-1 rows through the new method, carrying the numbers through.
7. **Why not a simpler fix?**: 2–3 obvious alternatives (a bigger baseline, hand-made features, other tricks),
   and why each falls short. Use the paper's own baselines and ablations.
8. **Proof of the mechanism**: the ablation, case study or analysis that isolates the idea, not just headline
   AUC. If the paper has none, say so on screen.
9. **Cost and limits**: parameters, latency, data needs, failure cases, and when not to use it.
10. **What came next**: links to other papers already filmed in `videos/`, both backward ("this fixes X's
    limit") and forward. Label a link "our reading" unless the paper itself says it.
11. **Interview drill** (the final 60–90 s): 5 cards (concept, math, trade-off, production, debugging), each
    with a spoken answer of 1–2 sentences. Put a small diagram or the key formula in each card's lower half so
    no card is half empty.

## INTERVIEW.md
- 12–15 questions, grouped as: concept, math/derivation, comparison, design trade-offs, production/serving,
  debugging/failure, extensions.
- Each has a 2–5 line answer that cites the paper (section, table or equation) or is marked **our reading**.
- Each has one "Follow-up:" an interviewer might ask next.
- Use the same format as `videos/ffm-why/INTERVIEW.md`.

## Rules
- One connected story, with the explainer's person in it.
- Facts trace to the paper. Label example values "example", call redrawn figures "a sketch of Figure N", and
  label anything not in the paper "our reading" on screen.
- Narration only (Kokoro af_heart), no music. Text at least 28 px.
- **Length 7–9 minutes, hard cap 9:00.** If the timing comes out longer, trim before rendering.
- HyperFrames contract:
  - Each composition is a `<template>` with `#root` and registers a paused GSAP timeline in
    `window.__timelines[id]`.
  - No CSS transform on elements GSAP animates.
  - No `Math.random`, and no stagger from "random".
  - Draw SVG strokes with `pathLength="1"` plus `strokeDashoffset`.
  - Mark deliberate stills with `data-hold`.
- STORYLINES.md line 1:
  `# Storylines (picked: A) — "Why <short name> works: <full paper title>, the deep dive" (<authors short>, <venue year>)`.
  Also write SPEC.md, script.json, timing.json and REVIEW.md.

## Commands
Prefix every command with `export PATH=/usr/local/bin:$PATH HYPERFRAMES_NO_TELEMETRY=1`, and run it from
`videos/<slug>-why`. Run hyperframes only in your own folder.
- TTS: `../../tts/.venv/bin/python tools/tts.py .` then `ffmpeg -y -i assets/narration.wav -b:a 160k assets/narration.mp3`
- `node tools/build-index.mjs`
- `npx --yes hyperframes@0.8.210 check` must report 0 errors.
- `npx --yes hyperframes@0.8.210 snapshot --at ...`: check the frames for overlaps and clipping, especially in
  equation and table scenes, and check that no table header is duplicated.
- `npx --yes hyperframes@0.8.210 render -o renders/<slug>-why.mp4 --quality high`
- `bash tools/finish.sh renders/<slug>-why.mp4` writes `<slug>-why-final.mp4`.
- Share copy: `ffmpeg -y -i renders/<slug>-why-final.mp4 -c:v libx264 -crf 26 -preset fast -c:a copy -movflags +faststart renders/<slug>-why-share.mp4`.
  It must be under 30 MB; if it isn't, raise crf.

**Speed:** run TTS, check, render, finish.sh and the share copy in the **foreground** (a Bash timeout of
600000 ms), never in the background. A background render you then wait on once cost an agent 30 idle minutes,
while a 9-minute film renders in about 5. Scene writing is the slow step (about half of a typical 15–20 min
build), so plan the scenes from script.json before you write them.

**Scrambled tables:** if a table in the pdftotext output is jumbled, re-extract it with the layout kept:
`pdftotext -layout paper.pdf - | grep -n -A15 "Table N"`.

## Verify before delivering
- Recompute every worked number in Python.
- Spoken numbers must match on-screen numbers.
- Check every paper number against the paper text. Papers have typos (for example, RankMixer's Table 6 prints
  20.7× where 2106 ÷ 107 = 19.7×). Flag these on screen or in INTERVIEW.md, don't copy them.
- Never commit or push the films or the `videos/` folders; they stay local.

## Report
Give the duration, a one-line scene list, the check result, the paths to the final and share mp4 and to
INTERVIEW.md, everything labelled "our reading", and any claims you were unsure of.
