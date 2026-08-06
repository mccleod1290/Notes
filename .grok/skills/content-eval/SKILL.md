---
name: content-eval
description: >-
  Optional structure/pedagogy eval (not default create). Chop AI slop, first
  principles map, core questions — three structure passes. Default document
  create is ONLY writer (simple-english 1x) → frugal-eval (simple-english 3x
  hardcore). Do NOT auto-invoke this skill after every draft. Invoke only when
  the operator says: run content-eval, structure eval, /content-eval, content
  eval, de-slop (structure), make this beginner friendly (structure pass), or
  3x content pass. Pairs with agent content_eval. Never replaces writer or
  frugal-eval or simple-english.
---

# content-eval (OPTIONAL)

## Default create (you are NOT in this path)

```text
writer (simple-english 1× pragmatic)
  → frugal-eval (simple-english 3× hardcore)
  → CREATE DONE
  → git → mail   (full ship)
```

**Only language skill on default create: simple-english.**  
This skill uses **content-eval** structure lenses — different job, **opt-in only**.

Rules: `rules/ship-pipeline-mandatory.md`, `rules/content-eval-mandatory.md`,
`AGENTS.md`.

## When to run (opt-in only)

Run **only** if the operator says one of:

- `run content-eval` / `structure eval` / `/content-eval`
- `content eval` / `3x content pass`
- explicit ask for structure / beginner-structure polish **after** STE

**Do not** auto-run after writer or frugal-eval.  
**Do not** treat “write notes” as a trigger for this skill.

If you are loaded by accident during normal create: stop and tell the parent
that create is writer → frugal-eval only.

## Prerequisites (if operator opted in)

1. Draft on disk (prefer **writer** + simple-english 1×)
2. **frugal-eval** simple-english 3× hardcore done (unless skip phrase)
3. Then this skill’s three structure passes

if the draft has not run **frugal-eval** and no skip phrase is present, run
frugal-eval (or spawn it) **before** this skill’s three passes.

## role

load agent profile **`content_eval`** (`.grok/agents/content_eval.md`).
you are that editor — **only when opt-in**.

upstream (default create — not you):

- **writer** — simple-english 1× pragmatic
- **frugal-eval** — simple-english 3× hardcore

prefer:

1. **in-process** 3-pass on the draft when operator asked
2. or `spawn_subagent` with `subagent_type: content_eval` for huge drafts

## the 3-pass loop (when opted in)

```text
draft
  → pass 1 slop_chop        → rewrite until PASS (max 2 rewrites)
  → pass 2 first_principles → rewrite until PASS (max 2 rewrites)
  → pass 3 core_questions   → rewrite until PASS (max 2 rewrites)
  → SHIP | REVISE | BLOCKED
```

**never** skip a pass when this skill is intentionally run.
**never** mark all PASS without edits unless the draft was already clean —
then list why each checklist item holds.

### pass 1 — slop_chop

kill AI tics, throat-clearing, restatements, hype. first useful sentence
early. cut 20–40% when truth allows. see agent body for ban list.

### pass 2 — first_principles

force: plain definition, why it exists, mechanism (input→transform→sink),
prereqs, high-level map, fundamental unit, when-to-use. bottom-up then
top-down. define jargon on first use.

### pass 3 — core_questions

list 3–7 core questions; each answered in-body or `gap`. kill vague steps.
add first-hit failure modes. skim test: headers + first lines enough?

## workflow (opt-in)

1. **confirm** operator asked for content_eval / structure eval
2. **locate draft** — path from user, or the file just written
3. **read** the full draft with tools (not memory)
4. **run pass 1 → 2 → 3** — edit file; record cuts
5. **write** cleaned file to the same path (unless report-only)
6. **report** using the agent output format (three verdicts + overall)

## report template

use the template in the `content_eval` agent. always include:

```text
overall: SHIP | REVISE | BLOCKED
path_written: ...
one_line_verdict: ...
```

## frugal rules

- shorter is better if true
- no praise, no emoji, no "great structure!"
- mark inventable technical gaps as `gap` — do not fabricate
- do not expand into a second document unless asked

## references

- [`references/slop-ban-list.md`](references/slop-ban-list.md)
- [`references/core-question-bank.md`](references/core-question-bank.md)
- agent: `.grok/agents/content_eval.md`
- STE skill (default create): `.agents/skills/simple-english/` · writer, frugal-eval
- rules: `rules/content-eval-mandatory.md` (optional), `rules/ship-pipeline-mandatory.md`, `AGENTS.md`
