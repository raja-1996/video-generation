"""Generate the narration with Kokoro: one WAV for the film plus timing.json (scene and line times)."""
import json, sys
import numpy as np
import soundfile as sf
from kokoro import KPipeline

SR = 24000
LEAD, LINE_GAP, SCENE_TAIL = 0.45, 0.32, 0.75

proj = sys.argv[1]
script = json.load(open(f"{proj}/script.json"))
pipe = KPipeline(lang_code="a", repo_id="hexgrad/Kokoro-82M")

out, t, scenes = [], 0.0, []
def pad(sec):
    global t
    out.append(np.zeros(int(round(sec * SR)), dtype=np.float32)); t += sec

for sc in script["scenes"]:
    start = t
    pad(LEAD)
    lines = []
    for i, text in enumerate(sc["lines"]):
        audio = np.concatenate([a for _, _, a in pipe(text, voice=script["voice"], speed=script["speed"])])
        dur = len(audio) / SR
        lines.append({"text": text, "start": round(t - start, 3), "dur": round(dur, 3)})
        out.append(audio.astype(np.float32)); t += dur
        if i < len(sc["lines"]) - 1:
            pad(LINE_GAP)
    pad(SCENE_TAIL)
    scenes.append({"id": sc["id"], "start": round(start, 3), "dur": round(t - start, 3), "lines": lines})
    print(f"{sc['id']:10s} {start:7.2f}s  {t - start:5.2f}s")

sf.write(f"{proj}/assets/narration.wav", np.concatenate(out), SR)
json.dump({"total": round(t, 3), "scenes": scenes}, open(f"{proj}/timing.json", "w"), indent=1)
print("total", round(t, 2))
