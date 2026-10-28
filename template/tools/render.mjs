// Renders the film with the fastest settings this machine allows.
// GPU present (Apple silicon, or a Linux render device): Chrome draws on the GPU and HyperFrames turns on fast
// capture by itself, so workers = performance cores - 2. No GPU: Chrome draws on the CPU, so workers = cores - 1
// (one core left for the encoder; 3 workers measured fastest on a 4-core container).
// Usage: node tools/render.mjs [-o renders/name.mp4] [any other hyperframes render flags]
// WORKERS=6 node tools/render.mjs overrides the worker count; a --workers flag wins over both.
import os from "node:os";
import fs from "node:fs";
import path from "node:path";
import { execSync, spawnSync } from "node:child_process";

const proj = path.resolve(path.dirname(new URL(import.meta.url).pathname), "..");
const args = process.argv.slice(2);
const sh = (cmd) => { try { return execSync(cmd, { stdio: ["ignore", "pipe", "ignore"] }).toString().trim(); } catch { return ""; } };

const mac = os.platform() === "darwin";
const appleSilicon = mac && os.arch() === "arm64";
const linuxGpu = os.platform() === "linux" && (fs.existsSync("/dev/dri/renderD128") || sh("command -v nvidia-smi") !== "");
const gpu = appleSilicon || linuxGpu;

const cores = os.availableParallelism();
const perfCores = Number(sh("sysctl -n hw.perflevel0.physicalcpu")) || cores; // macOS: performance cores only
const byMemory = Math.max(1, Math.floor(os.totalmem() / 2 ** 30)); // about 1 GB per Chrome worker, with headroom
const auto = gpu ? perfCores - 2 : cores - 1;
const workers = Number(process.env.WORKERS) || Math.max(1, Math.min(auto, byMemory));

const flags = [...args];
if (!flags.includes("-o") && !flags.includes("--output")) flags.unshift("-o", `renders/${path.basename(proj)}.mp4`);
if (!flags.includes("-q") && !flags.includes("--quality")) flags.push("--quality", "high");
if (!flags.some((f) => f === "-w" || f.startsWith("--workers"))) flags.push("--workers", String(workers));

// Use the HyperFrames version pinned in package.json, so the film re-renders identically.
const pkg = JSON.parse(fs.readFileSync(path.join(proj, "package.json"), "utf8"));
const pinned = (pkg.scripts?.render ?? "").match(/hyperframes@[\w.-]+/)?.[0] ?? "hyperframes";

console.log(`render: ${gpu ? "GPU" : "CPU only"} · ${cores} cores${mac ? ` (${perfCores} performance)` : ""} · ${flags.join(" ")}`);
const r = spawnSync("npx", ["--yes", pinned, "render", ...flags], { cwd: proj, stdio: "inherit", env: { HYPERFRAMES_NO_TELEMETRY: "1", ...process.env } });
process.exit(r.status ?? 1);
