#!/usr/bin/env bash
# Install Ronald's pi agent config onto this machine.
# Idempotent: backs up existing ~/.pi/agent first.
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
AGENT_DIR="$HOME/.pi/agent"
STAMP="$(date +%Y%m%d-%H%M%S)"

# 1. Back up existing config (if any)
if [ -d "$AGENT_DIR" ]; then
  BACKUP="$HOME/pi-agent-backup-$STAMP"
  echo "Backing up existing $AGENT_DIR -> $BACKUP"
  mkdir -p "$BACKUP"
  cp -R "$AGENT_DIR"/. "$BACKUP"/ 2>/dev/null || true
fi

mkdir -p "$AGENT_DIR/skills"

# 2. Copy config + skills (merge, don't clobber: keep local-only files)
echo "Installing settings + models + skills..."
cp -n "$REPO_DIR/pi/settings.json" "$AGENT_DIR/settings.json" 2>/dev/null || \
  cp "$REPO_DIR/pi/settings.json" "$AGENT_DIR/settings.json"
# 3. Models config — prefer private rws-models repo, fall back to example
MODELS_SRC=""
if [ -d "$HOME/rws-models" ]; then
  if git -C "$HOME/rws-models" rev-parse --git-dir >/dev/null 2>&1; then
    git -C "$HOME/rws-models" pull --ff-only || true
  fi
  [ -f "$HOME/rws-models/models.json" ] && MODELS_SRC="$HOME/rws-models/models.json"
fi
if [ -n "$MODELS_SRC" ]; then
  echo "Installing models.json from ~/rws-models (private repo)..."
  cp "$MODELS_SRC" "$AGENT_DIR/models.json"
else
  echo "Installing models.example.json — clone private repo for real providers:"
  echo "  git clone git@github.com:rw1018/rws-models.git ~/rws-models && re-run setup.sh"
  cp "$REPO_DIR/pi/models.example.json" "$AGENT_DIR/models.json"
fi
cp -R "$REPO_DIR/pi/skills/." "$AGENT_DIR/skills/"

echo ""
echo "Done. Next pi start pulls npm extensions from settings.json automatically."
echo "  - BRAVE_API_KEY must be set in env for the pi-brave-search extension."
echo "  - Custom model providers need Tailscale up (private rws-models repo)."
