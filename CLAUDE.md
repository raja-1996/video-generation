# video-generation

When the owner shares a paper link or asks for a paper video, use the `paper-to-video` skill
(`.claude/skills/paper-to-video/SKILL.md`): it writes three storylines, goes with its recommended one without
stopping, and builds and renders the whole video. Each paper gets **one** film (how + why together) in
`videos/<slug>-film/`, built by the scene order in `.claude/skills/paper-to-video/FILM.md`, starting from
`template/`. The old two-film pair (`<slug>-explainer` + `<slug>-why`, `WHY.md`) is deprecated since 2026-10-30.

Before making or editing a video here, read `docs/VIDEO_PLAYBOOK.md` (the owner's principles and the workflow)
and `docs/DESIGN.md` (the visual system). Key preferences:

- One connected story with a person in it; every formula shown first as a real-world process, then as symbols
  with each term named in plain words, and worked through with real numbers.
- Narration only (Kokoro `af_heart`); no music or sound effects.
- Facts and numbers trace to the source; example values are labelled.
- Never commit media (`*.mp4`, `*.wav`, `*.mp3`); finish renders with `tools/finish.sh`.
