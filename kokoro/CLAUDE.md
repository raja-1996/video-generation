# Kokoro TTS

Local text-to-speech (Kokoro-82M) in a uv venv.

## Setup

```bash
bash setup_kokoro.sh [target_dir]   # default: ./tts
```

The script installs espeak-ng and uv, creates a Python 3.12 venv, installs Kokoro, runs a test, and checks that `output.wav` is created.

- `SKIP_SYSTEM_DEPS=1` skips apt/brew.
- `TORCH_GPU=1` uses CUDA torch on Linux (CPU-only by default).

## Use

```bash
cd tts && .venv/bin/python test_kokoro.py
```

```python
from kokoro import KPipeline
pipeline = KPipeline(lang_code="a", repo_id="hexgrad/Kokoro-82M")  # a = US English, b = UK
audio = [a for _, _, a in pipeline("text", voice="af_heart")]  # 24 kHz
```

## Gotchas

- **Intel Mac:** needs `torch==2.2.2`, `transformers<4.50` and `numpy<2`. The script pins these.
- **Path length:** espeak-ng fails if the venv path is over 160 characters (`Error processing file .../phontab`). Use a short target dir.
- **First run** downloads the model weights from Hugging Face.
