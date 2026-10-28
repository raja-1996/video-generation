# Review: DCN-V2 explainer (5-minute cut, 22 scenes, ~307 s)

Added in the 5-minute cut: synthetic (known-answer tests), dials (DCN v1 vs v2), orders (why the keep step matters),
deep (stacked vs parallel), race (Criteo leaderboard, Table 6), lessons (production lessons, section 8),
budget (cross layers vs ReLU at fixed size, Table 7). Leaderboard and budget values are the paper's numbers;
dial angles and the gain-per-layer bars are illustrative and labelled so.

**Picked storyline:** A, the shopkeeper (see STORYLINES.md). Not built: B (matchmaker's grid), C (failing calculator).

## Creative calls
- Narrated by Kokoro (af_heart, local), 15 scenes, ~186 s at 1920x1080/30 fps. Voice only: no music or effects (requested).
- Every equation is shown as a real-world process first, then as symbols with words under each part:
  feature cross = "Madrid x English -> traveller"; cross layer = listen (W·x+b), combine (x0 ⊙, an AND circuit), keep (+x);
  stacking = one more "and" per layer; W = a readable who-matters-to-whom table; low rank = a few themes (hourglass);
  mixture of experts = specialists on a mixing desk with a gate; sigmoid + log loss = a probability gauge and the
  "sure and wrong" penalty curve -log(1-p).
- Script line changed for accuracy: two layers make trios (order 3), so the stack scene says "Madrid, and English, and 11 pm".

## Facts and what is illustrative
- From the paper: country x language example idea; DNNs inefficient at 2nd/3rd-order crosses and bigger = slower to serve;
  order grows by one per layer; Fig. 6 strong pairs (User x Movie, User x Gender) on MovieLens-1M; fast singular-value decay;
  rank = input size / 4 kept full accuracy in production; 0.6% AUCLoss gain vs production, 0.1% significant; hundreds of billions of examples.
- Illustrative (marked on screen where shown): 1,000-trait pair/trio counts (plain arithmetic), table shading other than the
  highlighted pairs, theme-strength bar heights, fader positions, the 74% tap chance, profile bar values.

## Measured vs looked at
- `hyperframes check`: passes (0 errors). Kept warnings: one lint note on number-counter proxy objects (no visual effect);
  the arcs in "listen" are SVG stroke draws the dead-stretch detector does not see (verified by snapshot), marked data-hold.
- Looked at: end-of-scene frames for all 15 scenes and the arc draw-on range. The voice was generated and timed, not listened to.

## Weakest shot / next
- The ledger scene's wall of pages shrinks and leaves empty kraft on the left; with more time, the wall would multiply
  outward instead. The experts scene's specialist icons are small.
