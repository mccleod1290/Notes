# HARD RULE: content_eval 3-pass

**Non-negotiable** when creating or polishing learning content.
Part of ship pipeline: `rules/ship-pipeline-mandatory.md`.

Runs **after** writer (STE 1×) and frugal-eval (STE hardcore 3×), unless those
steps were skipped with an explicit phrase.

## When

Notes, guides, checklists, templates, study docs, operator batches,
teaching READMEs, first-principles explainers, de-slop rewrites.

## Must

1. Draft on disk (prefer via **writer** — `rules/writer-mandatory.md`).
2. STE language gate done (prefer via **frugal-eval** —
   `rules/frugal-eval-mandatory.md`) unless skip phrase.
3. Run **content_eval** three sequential passes:

| Pass | Lens | Job |
|------|------|-----|
| 1 | `slop_chop` | Kill AI fluff; raise density |
| 2 | `first_principles` | Definition, mechanism, high-level map, beginner-clear |
| 3 | `core_questions` | Core Qs answered or gap; force clarity |

4. Rewrite on FAIL (max 2 per pass). Overall **SHIP** or **BLOCKED**.
5. Continue ship pipeline (git + mail) unless skip phrases.

## How

| piece | path |
|-------|------|
| agent | `.grok/agents/content_eval.md` |
| skill | `.grok/skills/content-eval/SKILL.md` → `/content-eval` |

Prefer in-process; optional `spawn_subagent` with `subagent_type: content_eval`.

### Upstream agents (hardcoded)

| Step | Agent | Skill |
|------|-------|-------|
| before | writer | simple-english 1× pragmatic |
| before | frugal-eval | simple-english 3× hardcore |
| this rule | content_eval | content-eval structure 3× |

content_eval is **not** a substitute for frugal-eval. Different lenses.

## Skip only if

- `skip content-eval` / `raw dump ok` / `no eval`
- pure mechanical change (typo/path) with no teaching prose

## Do not

- Ship first-draft AI prose as final
- Rubber-stamp three PASS with zero critique
- Invent facts to fill gaps — mark `gap`
- Skip frugal-eval by only running content_eval (unless skip phrase for STE)
