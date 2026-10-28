# HyperFrames

HTML-to-video rendering (HeyGen). Pages render in headless Chrome and FFmpeg encodes the frames.

## Setup

```bash
bash setup_hyperframes.sh [project_dir]   # default: ./hf-test
```

The script installs Node 22+, FFmpeg and the Linux Chrome libraries, then fetches Chrome. It creates a test project, renders it, and checks that `output.mp4` has a video stream.

- `SKIP_SYSTEM_DEPS=1` skips apt/brew.

## Use

```bash
npx hyperframes init my-video --non-interactive
cd my-video
npx hyperframes preview                   # Studio at http://localhost:3002
npx hyperframes render -o out.mp4         # --quality draft|standard|high, --fps, --format webm|mov|gif
npx hyperframes doctor                    # checks Chrome, FFmpeg, Node
```

## Gotchas

- **Requirements:** Node 22 or newer, plus FFmpeg. `npx hyperframes browser ensure` downloads Chrome.
- **Default output:** without `-o`, renders go to `renders/<project>_<date>_<time>.mp4`.
- **Containers or VMs with little RAM:** set `PRODUCER_LOW_MEMORY_MODE` and raise `--protocol-timeout`.
- **Telemetry:** turn it off with `HYPERFRAMES_NO_TELEMETRY=1`.
