<!-- claude-agent-kit:routing -->
## Agent routing

Subagents start cold: each one has to rebuild context you already have. Delegate
only when that cost pays off.

**Do it yourself (don't delegate):**
- Small edits: a few lines in one file, or an obvious fix.
- Hard problems: architecture, concurrency, tricky debugging,
  numerical/signal-processing correctness.
- Any task the coder already failed once. Take it over rather than re-delegating.

**scout** (haiku): broad searches across many files or naming variants when
you need only the conclusion. For a single known file or symbol, just Grep/Read.

**planner → coder → reviewer**: non-trivial features and refactors (multiple
files, or a design choice to make).
1. planner writes the spec. Skim it and correct it before passing it on.
2. coder implements the spec.
3. reviewer checks the diff against the spec. On FIXES REQUIRED, send the fix
   list back to coder once. If it fails again, fix it yourself.

**Delegating to coder:** always pass a tight spec: exact file paths, exact
changes (signatures, behavior), acceptance criteria including the test/lint
commands, and what's out of scope. Never send "implement X" without these.

**Verify, don't trust:** read agent reports critically. Check the diff yourself
before telling the user the work is done.
<!-- /claude-agent-kit:routing -->
