# claude-agents

A reusable Claude Code agent kit: four subagents plus global routing rules for
the main session. Install it into every Claude Code on the web session through
your cloud environment's setup script.

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

| Agent | Model | Tools | Role |
|-------|-------|-------|------|
| `planner` | opus | Read, Grep, Glob, WebFetch, WebSearch | Turns a request into a self-contained spec: files to touch, steps, acceptance criteria, risks. Never edits code. |
| `coder` | sonnet | Read, Edit, Write, Bash, Grep, Glob | Implements a spec exactly, with no redesign. Runs tests and linters, then reports files changed, test results, and anything unfinished. |
| `reviewer` | opus | Read, Grep, Glob, Bash | Checks the diff against the spec for correctness, edge cases, tests, security, and numerical issues. Returns `PASS` or a numbered list of required fixes. Never edits code. |
| `scout` | haiku | Read, Grep, Glob | Fast codebase search. Returns short conclusions with `path:line` references instead of file dumps. |

## Routing (`CLAUDE.md`)

These rules go in `~/.claude/CLAUDE.md` for the main session:

- Small edits: the main session does them directly (a subagent starts cold).
- Broad searches go to `scout`.
- Non-trivial features and refactors go through `planner` → `coder` → `reviewer`.
- The main session keeps hard problems itself: architecture, concurrency, tricky
  debugging, numerical/signal-processing work, and anything the coder already failed.
- Anything delegated to `coder` comes with a tight spec: paths, exact changes, and acceptance criteria.

## What `install.sh` does

- Copies `agents/*.md` into `~/.claude/agents/`, overwriting older copies.
- Copies `CLAUDE.md` to `~/.claude/CLAUDE.md` if that file doesn't exist yet.
  If it does exist, the script appends the kit section only when its marker
  comment (`<!-- claude-agent-kit:routing -->`) isn't already there, so your
  own content is never overwritten.
- It is idempotent, so running it again is safe.

To test it locally: `HOME=$(mktemp -d) bash install.sh`
