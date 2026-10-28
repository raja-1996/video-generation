# Review: InteractRank explainer (first cut, ~4:25)

Source: Khandagale et al., "InteractRank: Personalized Web-Scale Search Pre-Ranking with Cross Interaction
Features", Pinterest, WWW Companion '25 (arXiv 2504.06609). Storyline A, "the sorting office", picked by the owner.

## Choices

- **One search, start to finish.** Priya types "small balcony garden" at 7:40 am. Every scene is a step in serving
  that search, and the film ends on her phone with the herb box pin saved.
- **Two towers are two clerks who never meet.** The query clerk writes Priya's card now; the item clerk already
  wrote every pin's card (offline batch inference, §2.5.1). A wall between them is the blind spot.
- **IQP is a guestbook on the back of each pin.** It is a real-world process first (counting who searched and
  who saved), then `IQP = C(p,q) ÷ C(q)` with each term named, then worked: 120 ÷ 1,000 = 0.12.
- **The projection layer is a blend.** It is shown as "card match + guestbook → one score", then as
  `w × match + v × IQP + …`, then worked twice: herb box 1 × 0.92 + 3 × 0.12 = 1.28 beats a bench pin with a better
  card match (1.00) and an empty guestbook.
- **Worked math throughout.** Dot product 0.8·0.9 + 0.1·0 + 0.5·0.4 = 0.92; history attention
  0.6·0.9 + 0.3·0.6 + 0.1·0 = 0.72.
- **Results scenes** use Tables 2, 4 and 5 directly, bars from zero, the table named on screen.
- Length is ~4:25 rather than 3:00: the owner has asked for more worked math before, so the dot product,
  the guestbook and the blend each get a worked scene. Easy cuts if a 3-minute cut is wanted: `windows`, `learn`.

## What is illustrative (labelled on screen)

- Card values (0.8, 0.1, 0.5 / 0.9, 0, 0.4), guestbook counts (1,000 / 120 and the other rows), blend weights
  (1 and 3), the bench pin's 1.00, "120 old + 3 today", garden scores and attention weights.
- Priya, the herb box, the bench and the example search rows are invented.
- The blend shows one weight per guestbook line and "a constant"; the paper describes an affine layer over the dot
  product and the IQP features, implemented as WAND structured-query operators at serving time (§2.5.2).

## Facts and where they come from

| On screen | Source |
| --- | --- |
| ~10⁵ → ~10³ → ~10² pins | Fig. 1, §1 |
| cards of 64 numbers | §3.2.2 (embedding size 64) |
| 7 days, 90 days, 1 year, 2 years; split by country/gender; top searches only; incremental counts | §2.3, §2.5.3 |
| last 100 actions, real time, across surfaces; learned weighted pooling; query cross attention | §2.2.1, eq. 1–2 |
| yes/no label plus in-batch negatives, weights 1.0 and 0.01 | §2.4, §3.2.2 |
| HITS@3 +0 / +1.4 / +2.9%; FLOPs 127 / 3,069 / 142 | Table 2 |
| 10M users, one week, vs. proximity BM25; SIFR +2.7 / +3.6 / +6.5%, +3.7% over two towers | Table 4, §3.3 |
| HEAD/TORSO/TAIL/SINGLE SIFR changes | Table 5 (paper notes some values are not statistically significant) |
| deployed globally, billions of searches a day | §4 |

## Weakest shot

`segments` (popular vs. rare searches): it uses a small three-colour key, which the design system avoids, and the
narration has to point at the right bars. A stronger version would build it one segment at a time with direct labels.
Second weakest: the `morning` window reads more like dusk than morning.
