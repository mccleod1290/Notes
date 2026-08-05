---
name: content-eval
description: >-
  frugal content evaluation: chop AI slop, rewrite beginner-friendly from first
  principles (fundamental mechanism + high-level map), ask core clarifying
  questions, and force a mandatory 3-pass loop before shipping prose. Part of
  the HARDCODED vault pipeline: writer (simple-english 1x) → frugal-eval
  (simple-english 3x hardcore) → content_eval (this skill, 3x structure).
  AUTO-INVOKE after STE gate whenever you draft, write, rewrite, polish, or
  expand learning content. also when the user says content eval, de-slop, make
  this beginner friendly, first principles rewrite, chop the slop, 3x pass,
  run content_eval, or /content-eval. pairs with agent content_eval. does not
  replace writer or frugal-eval.
---

# content-eval

## HARDCODED pipeline (vault)

```text
writer (simple-english 1× pragmatic)
  → frugal-eval (simple-english 3× hardcore)
  → content_eval (this skill: 3 structure passes)   ← you are here
  → git → mail
```

agents: `.agents/writer.yaml`, `.agents/frugal-eval.yaml`,
`.grok/agents/content_eval.md`. rules: `AGENTS.md`,
`rules/ship-pipeline-mandatory.md`.

if the draft has not run **frugal-eval** and no skip phrase is present, run
frugal-eval (or spawn it) **before** this skill's three passes.

## auto-invoke (non-optional)

if this skill is in context and the task **produces or substantially edits**
learning content, you **must** complete the vault pipeline (STE via writer +
frugal-eval, then this 3-pass loop) before claiming done.

triggers (any is enough):

- writing/editing `*.md` notes, guides, checklists, templates, study docs
- user asks to "make notes", "write a guide", "operator batch", "document",
  "explain from first principles", "beginner friendly", "de-slop"
- `/content-eval` on a path or paste
- parent agent finished a content draft (after writer / frugal-eval)

skip only for: pure code without teaching prose, one-line path fixes, git
ops, or the user says `skip content-eval` / `raw dump ok`. STE skips are
separate: `skip ste` / `skip frugal-eval` (see ship-pipeline).

## role

load agent profile **`content_eval`** (`.grok/agents/content_eval.md` or
`~/.grok/agents/content_eval.md`). you are that editor.

upstream agents (not you):

- **writer** — `subagent_type: writer` — simple-english 1× pragmatic
- **frugal-eval** — `subagent_type: frugal-eval` — simple-english 3× hardcore

prefer:

1. **in-process** 3-pass on the draft (default; frugal)
2. or `spawn_subagent` with `subagent_type: content_eval` when the draft is
   huge and you need an isolated review

## the 3-pass loop (mandatory)

```text
draft
  → pass 1 slop_chop        → rewrite until PASS (max 2 rewrites)
  → pass 2 first_principles → rewrite until PASS (max 2 rewrites)
  → pass 3 core_questions   → rewrite until PASS (max 2 rewrites)
  → SHIP | REVISE | BLOCKED
```

**never** skip a pass. **never** mark all PASS without edits unless the draft
was already clean — then list why each checklist item holds.

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

## workflow

1. **locate draft** — path from user, or the file you just wrote
2. **read** the full draft with tools (not memory)
3. **run pass 1** — edit file or buffer; record cuts
4. **run pass 2** — edit again; fill definition/mechanism/map
5. **run pass 3** — edit again; answer core questions or ask human
6. **write** cleaned file to the same path (unless user asked report-only)
7. **report** using the agent output format (three verdicts + overall)

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

- [`references/slop-ban-list.md`](references/slop-ban-list.md) — phrases to delete
- [`references/core-question-bank.md`](references/core-question-bank.md) — starter questions by content type
- agent: `.grok/agents/content_eval.md`
- STE skill (upstream): `.agents/skills/simple-english/` · agents: writer, frugal-eval
- rules: `rules/content-eval-mandatory.md`, `rules/writer-mandatory.md`,
  `rules/frugal-eval-mandatory.md`, `rules/ship-pipeline-mandatory.md`, `AGENTS.md`
