# video-generation

Explainer videos made from research papers: HTML scenes rendered to video with
[HyperFrames](https://hyperframes.heygen.com), narrated locally with [Kokoro](https://huggingface.co/hexgrad/Kokoro-82M).

| Folder | What |
| --- | --- |
| `kokoro/` | setup script for Kokoro TTS (`bash kokoro/setup_kokoro.sh tts`) |
| `hyperframes/` | setup script for HyperFrames (`bash hyperframes/setup_hyperframes.sh`) |
| `dcn-v2-explainer/` | the DCN-V2 paper explainer (arXiv 2008.13535): 30 scenes, about 8 minutes |
| `docs/VIDEO_PLAYBOOK.md` | principles, preferences, the step-by-step workflow and the gotchas |
| `docs/DESIGN.md` | the visual system, with screenshots |

![DCN-V2 explainer](docs/screenshots/05-formula-in-words.jpg)

Videos and audio are not committed. To rebuild the DCN-V2 video:

```bash
bash kokoro/setup_kokoro.sh tts && bash hyperframes/setup_hyperframes.sh
cd dcn-v2-explainer
../tts/.venv/bin/python tools/tts.py .                        # narration.wav + timing.json
ffmpeg -i assets/narration.wav -b:a 160k assets/narration.mp3
node tools/build-index.mjs && npx hyperframes check
npx hyperframes render -o renders/dcn-v2.mp4 --quality high
bash tools/finish.sh renders/dcn-v2.mp4                       # phone-ready loudness
```
