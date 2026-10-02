# Learnings

Cases where agent routing went right or wrong, and the rule each one produced.
Sessions propose new entries through the self-review in `CLAUDE.md`. Add new
entries at the top, using the same four fields.

## 2026-10-02 — from a 3-day session

### Mistakes

1. **Harness default won.**
   - Decision: the main session did everything itself, because the harness's Agent tool says to spawn agents only when the user explicitly asks.
   - Cheaper: the delegations the rules describe.
   - Rule: CLAUDE.md opens with an explicit, permanent user request to use the kit's agents.

2. **"Hard problems stay" read too broadly.**
   - Decision: kept the mechanical multi-file implementation after the diagnosis was done.
   - Cheaper: hand coder a tight spec once the cause was known, then reviewer.
   - Rule: Diagnosis vs implementation. The main session keeps the diagnosis, not the whole task.

3. **No cost model.**
   - Decision: read whole files to orient; those tokens were re-processed by the most expensive model on every later step.
   - Cheaper: scout first, then read only the ranges it names.
   - Rule: Cost model and Orientation (no whole-file reads over ~150 lines to orient).

4. **No agent for the job.**
   - Decision: a general-purpose agent read an old session's transcript (~300k tokens, 104 tool calls).
   - Cheaper: ask the user one question; failing that, a targeted, capped search.
   - Rule: ask the user first; the `archivist` agent searches by keyword, stops when answered, reports in under 300 words.

5. **No transparency.**
   - Decision: agent usage was never stated; the user had to ask twice.
   - Cheaper: one line at the start, one in the summary.
   - Rule: Transparency.

6. **No learning loop.**
   - Decision: lessons were not captured, so each session repeats them.
   - Cheaper: three lines of self-review at the end of a long task.
   - Rule: Self-review, plus this file.

7. **Installer never updated.**
   - Decision: `install.sh` skipped `~/.claude/CLAUDE.md` when the marker was already there, so new rules never landed.
   - Cheaper: replace the marked block on every install.
   - Rule: begin/end markers; the block is replaced on every run.

### Right calls (keep doing these)

8. **Diagnosed subtle bugs with the code already in context.** A subagent would have re-read everything cold. Rule: Do it yourself (Diagnosis).

9. **Did small fixes directly.** The spec would have been as long as the code. Rule: keep the work when the spec ≈ the code.

10. **Self-reviewed its own diff before pushing.** It was cheap with the diff already loaded. Rule: Do it yourself (Self-review). Use reviewer for coder's diffs and for multi-file changes.
