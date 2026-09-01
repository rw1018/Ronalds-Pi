# Ronalds-Pi

My [pi](https://github.com/badlogic/pi-coding-agent) coding agent setup: extensions, custom local LLM providers, skills, and preferences.

## Contents

| Path | Installs to | What |
|---|---|---|
| `pi/settings.json` | `~/.pi/agent/settings.json` | Extension package list, theme, thinking budgets, default model |
| `pi/models.example.json` | `~/.pi/agent/models.json` | Template only — real providers live in private repo **rws-models** |
| `pi/skills/` | `~/.pi/agent/skills/` | `brave-search` (web search), `macos-harness` (native app control) |

Extensions are declared in `settings.json` as npm/git packages — pi installs them automatically on first start (no vendoring).

## Install

```bash
git clone git@github.com:rw1018/Ronalds-Pi.git
cd Ronalds-Pi
./setup.sh
```

`setup.sh` is idempotent and backs up any existing `~/.pi/agent` to `~/pi-agent-backup-<timestamp>` before touching anything.

## Requirements

- [pi](https://pi.dev) coding agent
- **Tailscale** up — model providers point at tailnet machines
- **`rws-models`** (private repo) for real model providers: `git clone git@github.com:rw1018/rws-models.git ~/rws-models`. Without it, `setup.sh` installs the example file instead.
- `BRAVE_API_KEY` env var for the `brave-search` skill
- Node.js (skill deps)

## What's in the stack

Extensions (from `settings.json`):

- `pi-caveman` — caveman mode
- `pi-token-speed` — token speed meter
- `pi-peon-ping`
- `pi-cc-extensions`
- `pi-agent-browser` — browser automation skill
- `@tmustier/pi-clean-slides` — PowerPoint inspection/editing
- `git:github.com/tmustier/pi-extensions` → `ralph-wiggum` (extension + skill)

Local model providers:

- `rws-rotterdam-worker-1` — Qwen 3.8 27B NVFP4 (llama.cpp, RTX)
- `rws-manila-worker-1` — Qwen 3.6 27B
- `rws-mac-studio-mlx` — DeepSeek V4 flash (MLX 4bit)
- `rws-mac-studio-qwen` — Qwen 3.8 27B uncensored (GGUF)
