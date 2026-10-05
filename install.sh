#!/usr/bin/env bash
# Installs the Claude Code agent kit into ~/.claude. Safe to re-run.
# The kit section of ~/.claude/CLAUDE.md is replaced on every run; content
# outside the markers is kept.
#
# Usage: install.sh [--local | --uninstall]
#   (none)       cloud install (Claude Code on the web)
#   --local      also install local overrides from local/agents/ (local CLI)
#   --uninstall  remove the kit's agents and its CLAUDE.md section
set -euo pipefail

[ $# -le 1 ] || { echo "error: too many arguments (try --help)" >&2; exit 1; }
mode=cloud
case "${1:-}" in
  "") ;;
  --local) mode=local ;;
  --uninstall) mode=uninstall ;;
  -h|--help) sed -n '2,9p' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
  *) echo "error: unknown option: $1 (try --help)" >&2; exit 1 ;;
esac

KIT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_DIR="${HOME}/.claude"
AGENTS_DIR="${CLAUDE_DIR}/agents"
BEGIN="<!-- claude-agent-kit:routing -->"
END="<!-- /claude-agent-kit:routing -->"

shopt -s nullglob
agents=("$KIT_DIR"/agents/*.md)
if [ ${#agents[@]} -eq 0 ]; then
  echo "error: no agents found in ${KIT_DIR}/agents" >&2
  exit 1
fi

if [ "$mode" = uninstall ]; then
  echo "Uninstalling Claude agent kit from ${CLAUDE_DIR}"
  for f in "${agents[@]}"; do
    a="${AGENTS_DIR}/$(basename "$f")"
    if [ -e "$a" ]; then rm -f "$a"; echo "  removed:   $a"; fi
  done
  target="${CLAUDE_DIR}/CLAUDE.md"
  if [ -e "$target" ] && grep -qxF "$BEGIN" "$target"; then
    if ! awk -v b="$BEGIN" -v e="$END" '$0==b{f=1} f&&$0==e{ok=1;exit} END{exit !ok}' "$target"; then
      echo "error: ${target} has ${BEGIN} without a matching ${END} after it;" \
        "fix it by hand. Left unchanged." >&2
      exit 1
    fi
    tmp="$(mktemp "${target}.XXXXXX")"
    # Drop the first BEGIN..END block.
    awk -v begin="$BEGIN" -v end="$END" '
      !done && !skip && $0 == begin { skip = 1; next }
      skip { if ($0 == end) { skip = 0; done = 1 } next }
      { print }
    ' "$target" > "$tmp"
    cp -f "$target" "${target}.bak"
    cat "$tmp" > "$target"
    rm -f "$tmp"
    echo "  CLAUDE.md: removed kit section from ${target} (backup: ${target}.bak)"
  fi
  echo "Done."
  exit 0
fi

mkdir -p "$AGENTS_DIR"

echo "Installing Claude agent kit (${mode}) from ${KIT_DIR}"

for f in "${agents[@]}"; do
  cp -f "$f" "$AGENTS_DIR/"
  echo "  agent:     ${AGENTS_DIR}/$(basename "$f")"
done
if [ "$mode" = local ]; then
  # Local overrides replace cloud-only agents (e.g. archivist).
  for f in "$KIT_DIR"/local/agents/*.md; do
    cp -f "$f" "$AGENTS_DIR/"
    echo "  agent:     ${AGENTS_DIR}/$(basename "$f") (local)"
  done
fi

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
