# OPTIONAL: content_eval 3-pass (not default)

**Not part of the default document create workflow.**

Default create is only:

```text
writer (simple-english 1×) → frugal-eval (simple-english 3× hardcore)
```

See `rules/ship-pipeline-mandatory.md`.

## When (opt-in only)

Run content_eval **only** if the operator says one of:

- `run content-eval`
- `structure eval`
- `/content-eval`

Do **not** auto-run after frugal-eval.

## What it is

Structure / pedagogy lenses (different skill — **not** simple-english):

| Pass | Lens | Job |
|------|------|-----|
| 1 | `slop_chop` | Kill AI fluff; raise density |
| 2 | `first_principles` | Definition, mechanism, high-level map |
| 3 | `core_questions` | Core Qs answered or gap |

Skill: `.grok/skills/content-eval/SKILL.md` · agent: `.grok/agents/content_eval.md`.

## Prerequisites if you opt in

1. Draft on disk via **writer** (simple-english 1×).
2. **frugal-eval** simple-english 3× hardcore done (unless skip phrase).
3. Then content_eval structure 3× if requested.

## Do not

- Treat this as mandatory create noise
- Use content_eval as a substitute for frugal-eval / simple-english
- Invent facts to fill gaps — mark `gap`
