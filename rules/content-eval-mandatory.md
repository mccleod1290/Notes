# HARD RULE: content_eval 3-pass

**Non-negotiable** when creating or polishing learning content.
Part of ship pipeline: `rules/ship-pipeline-mandatory.md`.

## When

Notes, guides, checklists, templates, study docs, operator batches,
teaching READMEs, first-principles explainers, de-slop rewrites.

## Must

1. Draft on disk.
2. Run **content_eval** three sequential passes:

| Pass | Lens | Job |
|------|------|-----|
| 1 | `slop_chop` | Kill AI fluff; raise density |
| 2 | `first_principles` | Definition, mechanism, high-level map, beginner-clear |
| 3 | `core_questions` | Core Qs answered or gap; force clarity |

3. Rewrite on FAIL (max 2 per pass). Overall **SHIP** or **BLOCKED**.
4. Continue ship pipeline (git + mail) unless skip phrases.

## How

| piece | path |
|-------|------|
| agent | `.grok/agents/content_eval.md` |
| skill | `.grok/skills/content-eval/SKILL.md` → `/content-eval` |

Prefer in-process; optional `spawn_subagent` with `subagent_type: content_eval`.

## Skip only if

- `skip content-eval` / `raw dump ok` / `no eval`
- pure mechanical change (typo/path) with no teaching prose

## Do not

- Ship first-draft AI prose as final
- Rubber-stamp three PASS with zero critique
- Invent facts to fill gaps — mark `gap`
