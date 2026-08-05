# Notes vault — agent rules

This is a **learning / operator notes** vault (not a live attack tree).

## content quality (mandatory)

Whenever you **create, rewrite, expand, or polish** learning content here:

1. Draft the file.
2. Run **content_eval** three passes before finishing:
   - **pass 1** `slop_chop` — kill AI fluff, raise density
   - **pass 2** `first_principles` — beginner-clear mechanism + high-level map
   - **pass 3** `core_questions` — answer or surface clarifying gaps
3. Ship only on overall **SHIP**, or stop with **BLOCKED** + short questions.

Sources of truth for the loop:

| piece | path |
|-------|------|
| rule | `.grok/rules/content-eval-mandatory.md` |
| skill | `.grok/skills/content-eval/SKILL.md` → `/content-eval` |
| agent | `.grok/agents/content_eval.md` (`subagent_type: content_eval`) |

Skip only if the user says `skip content-eval` / `raw dump ok`, or the change
is mechanical (typo/path) with no teaching prose.

## tone for this vault

- frugal, copy-paste useful, just-in-time why
- first principles over tour-guide fluff
- authorized-testing scope only when discussing attacks
