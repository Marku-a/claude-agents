# Local install

Use the kit with the Claude Code CLI (or IDE extension / desktop app) on your
own machine. For Claude Code on the web, see the setup script line in
[README.md](README.md) instead.

The local install is the same kit with one change: `archivist` reads your
local session transcripts in `~/.claude/projects/` instead of the cloud-only
`claude-code-remote` MCP server.

## Requirements

- [Claude Code](https://code.claude.com/docs) installed and signed in.
- `git` and `bash`:
  - **macOS / Linux:** already there.
  - **Windows:** install [Git for Windows](https://git-scm.com/download/win),
    which includes Git Bash (Claude Code on Windows uses it too). Run the
    commands below in **Git Bash**, not PowerShell or cmd. WSL also works if you
    run Claude Code inside WSL.

## Install

```bash
git clone -b master https://github.com/Marku-a/claude-agents ~/claude-agents
bash ~/claude-agents/install.sh --local
```

This writes:

- `~/.claude/agents/{scout,planner,coder,reviewer,archivist}.md`
- the routing rules into `~/.claude/CLAUDE.md`, between
  `<!-- claude-agent-kit:routing -->` markers. If you already have a
  `~/.claude/CLAUDE.md`, the kit section is appended and your content is kept.
  When a later install replaces an existing kit section, the old file is
  backed up to `~/.claude/CLAUDE.md.bak`.

Restart any running Claude Code session so it picks up the new agents.

## Check it worked

In a new session, run `/agents`, or ask "what agents are available?". You
should see `scout`, `planner`, `coder`, `reviewer` and `archivist`.

## Update

```bash
git -C ~/claude-agents pull
bash ~/claude-agents/install.sh --local
```

Agents are overwritten and the kit section of `CLAUDE.md` is replaced with
the current version. Content outside the markers is kept. Running it twice
changes nothing.

## Uninstall

```bash
bash ~/claude-agents/install.sh --uninstall
```

Removes the five kit agents from `~/.claude/agents/` and the kit section from
`~/.claude/CLAUDE.md` (backup at `~/.claude/CLAUDE.md.bak`). Your own content
in `CLAUDE.md` and any other agents are left alone. Then delete
`~/claude-agents` if you like.

## Notes

- **Customising.** Don't edit inside the markers in `~/.claude/CLAUDE.md` or the
  installed agent files; the next install overwrites them. Put your own rules
  outside the markers, or fork the repo and install from your fork.
- **Model access.** `planner` and `reviewer` use `opus`, `coder` uses `sonnet`,
  `scout` and `archivist` use `haiku`. If your plan doesn't include a model,
  change its `model:` line in your fork (or use `inherit`).
- **Archivist history.** Claude Code deletes local transcripts older than
  `cleanupPeriodDays` (30 by default). Raise it in `~/.claude/settings.json`
  if you want archivist to reach further back.
- **Try it without touching your setup:** `HOME=$(mktemp -d) bash install.sh --local`
