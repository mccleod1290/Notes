# Source

Installed from: https://github.com/AminBlg/SimpleEnglish
Skill path upstream: `skills/simple-english/`
License: MIT (see LICENSE)

Vault usage (hardcoded — **only** language skill on default create):

| Agent | Mode | Passes | Contract |
|-------|------|--------|----------|
| writer | pragmatic | 1 | `.agents/writer.yaml` |
| frugal-eval | hardcore (strict + checklist) | 3 | `.agents/frugal-eval.yaml` |

Default create: writer → frugal-eval (both load this skill).  
content_eval does **not** use this skill and is opt-in only.

See `AGENTS.md`, `rules/writer-mandatory.md`, `rules/frugal-eval-mandatory.md`,
`rules/ship-pipeline-mandatory.md`.
