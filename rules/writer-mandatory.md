# HARD RULE: writer agent (draft + STE 1×)

**Non-negotiable** when creating or substantially expanding learning content.
Part of ship pipeline: `rules/ship-pipeline-mandatory.md`.

## When

Notes, guides, checklists, templates, study docs, operator batches, cram cards,
teaching READMEs, first-principles explainers — any prose the user will learn from.

## Must

1. Use agent **writer** (not a free-form draft with no STE).
2. Write the draft **on disk** (topic folders: `AI/`, `api/`, `agriculture/`, …).
3. Study/course topics: finish **study research pack** first
   (`rules/study-sources-mandatory.md`).
4. Load and apply skill **simple-english** exactly **once**:
   - path: `.agents/skills/simple-english/SKILL.md`
   - mode: **pragmatic**
   - passes: **1**
5. Hand off to **frugal-eval** on the same path (do not claim final ship).

## How

| piece | path |
|-------|------|
| YAML contract | `.agents/writer.yaml` |
| agent body (`.agents`) | `.agents/writer.md` |
| Grok spawn body | `.grok/agents/writer.md` |
| skill | `.agents/skills/simple-english/` (also `.grok/skills/simple-english/`) |

Prefer `spawn_subagent` with `subagent_type: writer`, or in-process with the
same contract loaded.

### Card shape (default operator / cram)

FILL IN → GOAL → TIME → YOU NEED → WHY → DO THIS → IF/THEN → NEXT.

### STE pragmatic (1×)

- Procedural: imperative, ≤20 words/sentence, one instruction per sentence
- Descriptive: simple tenses, ≤25 words/sentence
- Active voice; ban should/would/may/might
- Condition before command; one word one meaning per file
- Never rewrite code, paths, commands, quoted errors

## After writer

Always: **frugal-eval** (`rules/frugal-eval-mandatory.md`) → then content_eval
→ git → mail unless skip phrases.

## Skip only if

- `skip ste` / `skip simple-english` / `skip writer ste` / `ship pipeline off`
- pure mechanical change (typo/path) with no teaching prose

## Do not

- Run frugal-eval’s 3× loop yourself (that is frugal-eval)
- Ship first draft without STE 1× (unless skip phrase)
- Invent domain facts — mark `gap`
