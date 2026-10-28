# Storylines (picked: A): InteractRank (arXiv 2504.06609)

Paper: Khandagale et al., "InteractRank: Personalized Web-Scale Search Pre-Ranking with Cross Interaction
Features", Pinterest, WWW Companion '25. Planned length: about 3 minutes, Kokoro `af_heart` narration only.

**Recommendation: A.** It puts the paper's real tension (a stopwatch versus two towers that never meet)
inside one search, and its guestbook makes the IQP formula a count anyone can check.

## A. The sorting office (recommended)

- **Person and situation.** Priya, 7:40 am, coffee in hand, types "small balcony garden" into Pinterest.
  Retrieval has already pulled about a hundred thousand pins; a few thousand may go on.
- **Device.** A sorting office on the kraft workbench, with a stopwatch on the wall. Each pin is an envelope.
  The two towers are two clerks who never talk: one writes Priya's request card, the other has already
  written every pin's card the night before (offline item embeddings). The score is how well the cards line
  up (dot product). The fix: a **guestbook** pasted on each envelope's back, "searched 'balcony garden' —
  shown 1,000 times, saved 120" (IQP = C(p,q) / C(q)), read in one glance (forward-index lookup).
- **First two seconds.** A phone in a dim kitchen; the search box types itself; a stopwatch starts.
- **Beats.** Funnel 10¹⁰ → 10⁵ → 10³ → 10² → the stopwatch problem → two clerks, two cards, dot product
  worked with 3 numbers → the blind spot (the clerks never meet) → the guestbook, IQP worked with example
  counts, 7 days to 2 years → the final score: dot product plus weighted guestbook lines (worked) → Priya's
  last 100 saves: plain average vs. query-focused attention (worked) → how it learns (saved or not, plus
  in-batch "wrong envelopes") → results: 142 vs 3,069 FLOPs, +6.5% / +3.7% SIFR, and the popularity
  segments (guestbooks are full for popular searches, empty for rare ones) → Priya saves a pin.
- **Look.** DESIGN.md kraft workbench and night/morning phone world: envelopes as tags, guestbook as a
  ledger strip, red stamp for the winning pin.

## B. Two strangers and a guestbook

- **Person and situation.** Priya again, but the film is told from one pin's side: a photo of a herb box on
  a railing, waiting in a crowd of 100,000 to be picked.
- **Device.** A dating-show matchmaker who must pair them without letting them meet: each fills in a profile
  separately (two towers), compatibility is the overlap. The pin's secret weapon is its guestbook of past
  searchers who loved it.
- **First two seconds.** A crowd of pin cards, one lifts its head as the query arrives.
- **Beats.** Same math, ordered around the pin's chances: rejected on profile alone, rescued by its
  guestbook, then personalised by Priya's history.
- **Look.** Warmer, character-led; pins with faces drawn as simple shapes. Riskier: anthropomorphism can
  blur what the model actually does.

## C. The stopwatch budget

- **Person and situation.** An engineer, Dev, on call, watching a latency graph while Priya's search
  comes in.
- **Device.** Every operation costs coins from a fixed budget per request. A two tower dot product costs
  127 coins, InteractRank 142, IntTower 3,069. The film is a budget negotiation.
- **First two seconds.** A coin jar and a 10 ms timer on a desk.
- **Beats.** Funnel as budget allocation → why big ranking models are banned here → each InteractRank
  component justified by its coin cost and its gain (Tables 2 and 3) → A/B result.
- **Look.** Ledger and coins; strongest on the efficiency story, weakest on intuition for the formulas.
