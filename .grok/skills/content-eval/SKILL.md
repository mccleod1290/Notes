---
name: content-eval
description: >-
  frugal content evaluation: chop AI slop, rewrite beginner-friendly from first
  principles (fundamental mechanism + high-level map), ask core clarifying
  questions, and force a mandatory 3-pass loop before shipping prose. AUTO-INVOKE
  whenever you draft, write, rewrite, polish, or expand learning content —
  notes, guides, checklists, operator batches, study docs, writeups, README
  teaching sections, templates, engagement notes, IIS/AI/web notes, or any
  markdown the user will learn from. also when the user says content eval,
  de-slop, make this beginner friendly, first principles rewrite, chop the
  slop, 3x pass, run content_eval, or /content-eval. after any content write,
  run three passes (slop_chop → first_principles → core_questions) and only
  SHIP on overall pass. pairs with agent content_eval.
---

# content-eval

## auto-invoke (non-optional)

if this skill is in context and the task **produces or substantially edits**
learning content, you **must** run the 3-pass loop before claiming done.

triggers (any is enough):

- writing/editing `*.md` notes, guides, checklists, templates, study docs
- user asks to "make notes", "write a guide", "operator batch", "document",
  "explain from first principles", "beginner friendly", "de-slop"
- `/content-eval` on a path or paste
- parent agent finished a content draft

skip only for: pure code without teaching prose, one-line path fixes, git
ops, or the user says `skip content-eval` / `raw dump ok`.

## role

load agent profile **`content_eval`** (`.grok/agents/content_eval.md` or
`~/.grok/agents/content_eval.md`). you are that editor.

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
