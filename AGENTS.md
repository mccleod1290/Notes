# Notes vault — agent rules

Learning / operator notes vault (not a live attack tree).

## Hard rules (canonical under `rules/`)

**Do not duplicate policy here.** Read and obey these files:

| Rule | Path |
|------|------|
| **Ship pipeline** (content gen → content_eval 3× → git push → mail) | [`rules/ship-pipeline-mandatory.md`](rules/ship-pipeline-mandatory.md) |
| **content_eval 3-pass loop** | [`rules/content-eval-mandatory.md`](rules/content-eval-mandatory.md) |
| **Study research pack** (official docs + gold-mine blogs) | [`rules/study-sources-mandatory.md`](rules/study-sources-mandatory.md) |
| Index | [`rules/README.md`](rules/README.md) |

Also loaded for harness auto-discovery via `.grok/rules/` (symlinks → `rules/`).

**Default:** every keepable deliverable runs the full ship pipeline unless the
operator uses an explicit skip phrase listed in `rules/ship-pipeline-mandatory.md`.

## content_eval tooling

| piece | path |
|-------|------|
| agent | `.grok/agents/content_eval.md` |
| skill | `.grok/skills/content-eval/SKILL.md` → `/content-eval` |

## Tone

- frugal, copy-paste useful, just-in-time why
- first principles over tour-guide fluff
- authorized-testing scope only when discussing attacks
