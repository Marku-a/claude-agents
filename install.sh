#!/usr/bin/env bash
# Installs the Claude Code agent kit into ~/.claude. Safe to re-run.
set -euo pipefail

KIT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_DIR="${HOME}/.claude"
AGENTS_DIR="${CLAUDE_DIR}/agents"
MARKER="<!-- claude-agent-kit:routing -->"

mkdir -p "$AGENTS_DIR"

echo "Installing Claude agent kit from ${KIT_DIR}"

shopt -s nullglob
agents=("$KIT_DIR"/agents/*.md)
if [ ${#agents[@]} -eq 0 ]; then
  echo "error: no agents found in ${KIT_DIR}/agents" >&2
  exit 1
fi
for f in "${agents[@]}"; do
  cp -f "$f" "$AGENTS_DIR/"
  echo "  agent:     ${AGENTS_DIR}/$(basename "$f")"
done

target="${CLAUDE_DIR}/CLAUDE.md"
if [ ! -e "$target" ]; then
  cp "$KIT_DIR/CLAUDE.md" "$target"
  echo "  CLAUDE.md: created ${target}"
elif grep -qF "$MARKER" "$target"; then
  echo "  CLAUDE.md: ${target} already has kit section, left unchanged"
else
  { printf '\n'; cat "$KIT_DIR/CLAUDE.md"; } >> "$target"
  echo "  CLAUDE.md: appended kit section to ${target}"
fi

echo "Done."
