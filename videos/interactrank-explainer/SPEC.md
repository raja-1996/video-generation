GOAL:    the viewer understands why search pre-ranking uses two towers (fast because pin cards are made ahead of
         time), what they miss (they never see what people searched and then saved), and how InteractRank fixes it
         cheaply with looked-up counts (IQP) blended into the score, plus the real-time history and the results.
OUTPUT:  HyperFrames, 1920 x 1080, 30 fps
TIME:    ~262 s of narration + 3.4 s end hold; the narration (Kokoro af_heart, assets/narration.mp3) is the clock;
         scene windows from timing.json
SOUND:   voice only (owner's preference); no music, no effects.
LOOK:    Two worlds, from docs/DESIGN.md.
         MORNING (Priya): ground #16233F lightening to a dawn window (#f2c46d horizon), a phone 900 px tall with a
         Pinterest-style search screen #FBF6EC.
         SORTING OFFICE (the model): kraft #D8B98A with 9% fibre noise; ink #221C16; cards and pins #F6E9CC with 4 px ink
         outline; ONE accent red #B52A1F per frame (the guestbook term, the winning number, the winning bar);
         lamp yellow #F5B921 only for "ready / on".
         Display: Archivo Black 64-130 px. Body/labels: Nunito 700-900, >= 28 px.
OBJECTS: pin cards (a picture block + caption); two clerks at desks with a wall between them (the two towers);
         index cards with three numbers (embeddings); a guestbook ledger on the back of a pin (IQP);
         ledger tabs for time windows; a stopwatch; tiles for her last 100 actions; bar charts from Tables 2, 4, 5.
MOTION:  arrivals expo.out / power4.out 0.4-0.7 s; moves power2.inOut; exits power3.in 0.25 s;
         cards drop in back.out(1.4); stamps hit 1.5x set then 0.14 s settle; titles blur 8px -> 0 in 0.2 s.
         Card flips by squashing scaleX (no 3D backface).
SHOTS:   one per narration scene (timing.json); each part appears on the line that names it.
BANNED:  dark void with floating UI; glow/particles; purple/blue gradients; three cards in a row as a layout;
         bullet slides; everything fading up at once; text that moves while read; narration repeated on screen.
FACTS:   every number from the paper (Fig. 1, §2.2-2.5, §3.2.2, Tables 2, 4, 5); card values, guestbook counts,
         blend weights, garden scores and attention weights are example values and say so on screen.
