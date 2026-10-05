# claude-agents

A reusable Claude Code agent kit: five subagents plus global routing rules for
the main session. Install it into every Claude Code on the web session through
your cloud environment's setup script.

**Working locally?** (Claude Code CLI, IDE extension or desktop app on your own
machine) Follow [LOCAL.md](LOCAL.md):

```bash
git clone -b master https://github.com/Marku-a/claude-agents ~/claude-agents
bash ~/claude-agents/install.sh --local
```

## Setup script

Paste this line into your cloud environment's setup script:

```bash
git clone --depth 1 -b master https://github.com/Marku-a/claude-agents /tmp/claude-kit && bash /tmp/claude-kit/install.sh || true
```

The only requirements are `bash` and `git`.

`-b master` downloads the `master` branch regardless of which branch is the
repository's default.

`|| true` keeps the session starting even if the clone or install fails (for
example, a network error). The agents are then missing, so if they don't show
up, ask the session "what agents are available?" to check.

## Agents

| Agent | Model | Tools | Use proactively when |
|-------|-------|-------|------|
| `scout` | haiku | Read, Grep, Glob | The repo is unfamiliar, the question is "where/how does X work", or a search spans more than 2 files. Returns `path:line` refs and key functions as ranges, not file dumps. |
| `planner` | opus | Read, Grep, Glob, WebFetch, WebSearch | A feature has real design choices. Writes a self-contained spec. Never edits code. |
| `coder` | sonnet | Read, Edit, Write, Bash, Grep, Glob | A diagnosed fix spans 2+ files or adds tests. Implements the spec exactly, runs the given test command, reports pass/fail counts and tests it couldn't run. |
| `reviewer` | opus | Read, Grep, Glob, Bash | After coder, or before pushing a multi-file change. Returns `PASS` or a numbered list of required fixes. Never edits code. |
| `archivist` | haiku | inherited (see below) | A question about a past session that the user can't answer. Searches by keyword, stops when answered, reports in under 300 words with event ids. |

Model choice follows the cost model: haiku for search, sonnet for
implementation, opus only for judgement-heavy planning and review.

Each description starts with "Use PROACTIVELY when…" and names concrete
triggers, because the harness picks agents by their description.

`archivist` reads sessions through the `claude-code-remote` MCP server, which the
cloud harness provides rather than your config. So `mcpServers:` can't name it,
and MCP names in `tools:` aren't documented. The agent therefore omits `tools:`
and inherits the session's tools; its prompt restricts it to `list_sessions`,
`list_events` and `get_event`, and tells it to load them through ToolSearch when
they are deferred. It never copies secrets; it cites the event id instead.

## Routing (`CLAUDE.md`)

These rules go in `~/.claude/CLAUDE.md` for the main session.

**Standing authorization.** The Claude Code harness tells the main session not
to spawn agents unless the user explicitly asks. User instructions in CLAUDE.md
override harness defaults, but only when they are explicit. So the kit section
opens with an explicit, permanent request to use these agents. Without it, the
main session does everything itself.

**Cost model.** The main context is re-processed on every step, so tokens read
early are paid many times. Delegate when output << input (search, research) or
spec << work (mechanical multi-file edits plus tests). Keep the work when the
spec ≈ the code, the context is already loaded, or it's diagnosis. Ask the user
first when one message would answer it.

Also in the section: scout-first orientation, diagnosis vs implementation,
transparency (name the agents up front, report savings at the end),
verification, prerequisites up front, safety, and a self-review that proposes
`LEARNINGS.md` entries.

## Learning loop (`LEARNINGS.md`)

A log of routing cases: date, decision, cheaper alternative, and the rule it
produced. After a long or costly task, the session writes a 3-line self-review
and offers it as an entry. Fold recurring lessons into `CLAUDE.md` and re-run
the installer.

## What `install.sh` does

- Copies `agents/*.md` into `~/.claude/agents/`, overwriting older copies.
- Creates `~/.claude/CLAUDE.md` from the kit's `CLAUDE.md` if it doesn't exist.
- Otherwise it manages the block between `<!-- claude-agent-kit:routing -->` and
  `<!-- /claude-agent-kit:routing -->`:
  - no block: appends it;
  - block present: replaces the whole block with the current kit version, so
    existing installs get new rules. Content outside the markers is kept. A
    backup goes to `~/.claude/CLAUDE.md.bak` when anything changes.
- It is idempotent: a second run changes nothing.
- `--local` also copies `local/agents/*.md` over the cloud versions. Today
  that is `archivist`, which reads `~/.claude/projects/**/*.jsonl` transcripts
  with Read, Grep and Glob instead of the cloud MCP tools.
- `--uninstall` removes the kit's agents and its marked `CLAUDE.md` block
  (with a `.bak` backup), keeping everything else.

Don't edit inside the markers; your edits are overwritten on the next install.
Put your own rules outside them.

To test it locally: `HOME=$(mktemp -d) bash install.sh`
