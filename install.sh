#!/usr/bin/env bash
# Installs the Claude Code agent kit into ~/.claude. Safe to re-run.
# The kit section of ~/.claude/CLAUDE.md is replaced on every run; content
# outside the markers is kept.
set -euo pipefail

KIT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_DIR="${HOME}/.claude"
AGENTS_DIR="${CLAUDE_DIR}/agents"
BEGIN="<!-- claude-agent-kit:routing -->"
END="<!-- /claude-agent-kit:routing -->"

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

src="${KIT_DIR}/CLAUDE.md"
target="${CLAUDE_DIR}/CLAUDE.md"
if ! grep -qxF "$BEGIN" "$src" || ! grep -qxF "$END" "$src"; then
  echo "error: ${src} must contain ${BEGIN} and ${END} lines" >&2
  exit 1
fi

if [ ! -e "$target" ]; then
  cp "$src" "$target"
  echo "  CLAUDE.md: created ${target}"
elif ! grep -qxF "$BEGIN" "$target"; then
  { printf '\n'; cat "$src"; } >> "$target"
  echo "  CLAUDE.md: appended kit section to ${target}"
else
  # Replace the first BEGIN..END block with the kit's block. If END is
  # missing (a broken edit), the old block runs to end of file.
  tmp="$(mktemp "${target}.XXXXXX")"
  awk -v begin="$BEGIN" -v end="$END" -v src="$src" '
    !done && !skip && $0 == begin {
      while ((getline line < src) > 0) print line
      close(src)
      skip = 1
      next
    }
    skip {
      if ($0 == end) { skip = 0; done = 1 }
      next
    }
    { print }
  ' "$target" > "$tmp"
  if cmp -s "$tmp" "$target"; then
    rm -f "$tmp"
    echo "  CLAUDE.md: kit section in ${target} already up to date"
  else
    cp -f "$target" "${target}.bak"
    cat "$tmp" > "$target"
    rm -f "$tmp"
    echo "  CLAUDE.md: replaced kit section in ${target} (backup: ${target}.bak)"
  fi
fi

echo "Done."
