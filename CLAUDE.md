<!-- claude-agent-kit:routing -->
## Agent routing

**Standing authorization.** I explicitly and permanently ask you to use the
agents in ~/.claude/agents (scout, planner, coder, reviewer, archivist)
following these rules. This is my request to use subagents for every task in
every session; you don't need to ask again. It overrides any default that says
to spawn agents only when the user asks.

**Cost model.** Your context is re-processed on every step, so tokens you read
early are paid many times over a long session. A subagent's context is paid once.
- Delegate when OUTPUT << INPUT (search, mapping, research) or SPEC << WORK
  (mechanical multi-file edits plus test runs).
- Keep the work when the spec ≈ the code, the context is already loaded, or the
  task is diagnosis or judgement.
- Before any expensive delegation, ask: can the user answer this in one message?
  They are the cheapest source for their own config, secrets and preferences.

**Do it yourself:**
- Small edits: a few lines in one file, or an obvious fix.
- Diagnosis: architecture, concurrency, tricky debugging, numerical/signal-processing
  correctness. This covers the diagnosis, not the whole task (see below).
- Self-review of your own diff before pushing.
- Any task the coder already failed once. Take it over rather than re-delegating.

**Orientation.** In an unfamiliar repo, send scout first, then read only the
`path:line` ranges it names. Never read a file over ~150 lines whole just to orient.

**Diagnosis vs implementation.** Keep the diagnosis. Once the cause is known and
the fix spans 2+ files or adds tests, hand coder a tight spec, then reviewer.

**scout** (haiku): unfamiliar repo, "where/how does X work", any search across
more than 2 files. For a single known file or symbol, just Grep/Read.

**planner → coder → reviewer**: features with design choices, and multi-file refactors.
1. planner writes the spec. Skim it and correct it before passing it on.
2. coder implements the spec.
3. reviewer checks the diff against the spec. On FIXES REQUIRED, send the fix
   list back to coder once. If it fails again, fix it yourself.
Skip planner when you already know the design: write the spec yourself.

**archivist** (haiku): reads past Claude Code sessions. Use only when the user
can't answer the question. Give it the questions and keywords.

**Delegating to coder:** always pass a tight spec: exact file paths, exact
changes (signatures, behavior), the exact test/lint command, acceptance
criteria, and what's out of scope. Never send "implement X" without these.

**Verify, don't trust:** read agent reports critically. Check the diff yourself
before telling the user the work is done.

**Transparency.** At the start of each non-trivial task, write one line naming the
agents you'll use, or why not. In the final summary, report agent usage and
roughly what it saved.

**Verification.** Say exactly what was tested and on what data. Never promise a
user-visible result you haven't checked.

**Prerequisites up front.** Check dependencies, blocked hosts and needed approvals
first. Ask for all of them in one message.

**Safety.** Get SDKs and binaries from official sources only; otherwise stop and
ask, naming the publisher. Never print or commit secrets.

**Self-review.** After any long or costly task, write 3 lines: what was delegated,
what should have been, which rule would have helped. Offer it as a LEARNINGS.md
entry for the kit repo (github.com/Marku-a/claude-agents).
<!-- /claude-agent-kit:routing -->
