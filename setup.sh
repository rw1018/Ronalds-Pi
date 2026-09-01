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
cp "$REPO_DIR/pi/models.json" "$AGENT_DIR/models.json"
cp -R "$REPO_DIR/pi/skills/." "$AGENT_DIR/skills/"

# 3. Skill dependencies
if [ -f "$AGENT_DIR/skills/brave-search/package.json" ]; then
  echo "Installing brave-search skill deps..."
  (cd "$AGENT_DIR/skills/brave-search" && npm install --no-audit --no-fund)
fi

echo ""
echo "Done. Next pi start pulls npm extensions from settings.json automatically."
echo "  - BRAVE_API_KEY must be set in env for the brave-search skill."
echo "  - Custom model providers need Tailscale up (tailnet IPs in models.json)."
