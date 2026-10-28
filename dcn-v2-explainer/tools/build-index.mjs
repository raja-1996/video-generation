// Writes index.html from timing.json: one host per scene, the narration track, shared styles.
import fs from "node:fs";
const t = JSON.parse(fs.readFileSync(new URL("../timing.json", import.meta.url)));
const END_HOLD = 3.4; // the closing line holds after the voice ends
const total = +(t.total + END_HOLD).toFixed(2);
const scenes = t.scenes.filter((s) => fs.existsSync(new URL(`../compositions/${s.id}.html`, import.meta.url)));
const hosts = scenes.map((s, i) => {
  const dur = s.id === "close" ? +(s.dur + END_HOLD).toFixed(2) : s.dur;
  return `      <div id="${s.id}" data-composition-id="${s.id}" data-composition-src="compositions/${s.id}.html" data-start="${s.start}" data-duration="${dur}" data-track-index="1" data-track-kind="graphics" data-width="1920" data-height="1080"></div>`;
}).join("\n");
const shared = fs.readFileSync(new URL("./shared.css", import.meta.url), "utf8");
fs.writeFileSync(new URL("../index.html", import.meta.url), `<!doctype html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=1920, height=1080" />
    <script src="https://cdn.jsdelivr.net/npm/gsap@3.14.2/dist/gsap.min.js"></script>
    <style>
${shared}
    </style>
  </head>
  <body>
    <div id="root" data-composition-id="main" data-start="0" data-duration="${total}" data-width="1920" data-height="1080">
${hosts}
      <audio id="voice" class="clip" src="assets/narration.mp3" data-start="0" data-duration="${t.total}" data-track-index="0" data-volume="1"></audio>
    </div>
    <script>
      window.__timelines = window.__timelines || {};
      window.__timelines["main"] = gsap.timeline({ paused: true });
    </script>
  </body>
</html>
`);
console.log("index.html: total", total, "s,", t.scenes.length, "scenes");
