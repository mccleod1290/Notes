# HARD RULE: writer agent (draft + simple-english 1×)

**Non-negotiable** first half of document create.
Pair: **frugal-eval** (simple-english 3× hardcore) — see
`rules/frugal-eval-mandatory.md`. Pipeline: `rules/ship-pipeline-mandatory.md`.

## Create workflow (only this + frugal-eval)

```text
writer  →  simple-english 1× pragmatic  →  handoff frugal-eval
```

**Skill is mandatory.** Every writer run **must** load and apply
`.agents/skills/simple-english/SKILL.md`. No draft handoff without that pass.

## When

Notes, guides, checklists, templates, study docs, operator batches, teaching
READMEs, first-principles explainers — any prose that builds **operator /
architect** skill (bug bounty path). Default audience is the vault owner, not
a university exam board.

## Must

1. Use agent **writer** (not a free-form draft with no STE).
2. Write the draft **on disk** (core folders: `AI/`, `api/`, `IIS/`, `AEM/`,
   `web-app-testing/`, `Checklists/`, … — see `AGENTS.md` purpose).
3. Facts: do not invent caps/APIs — research when needed
   (`rules/study-sources-mandatory.md`); mark `gap` otherwise.
4. **Learning topics: write two files** (see `rules/two-doc-ship-mandatory.md`):
   - `TOPIC-principles.md` — first principles, gotchas, **critical** tips only
   - `TOPIC-references.md` — official + gold-mine links with so-what / extra tips
   - Templates: `Templates/topic-principles.md`, `Templates/topic-references.md`
   - Do not mix URL tables into Doc 1. Cap critical tips (3–7 per list).
5. Load and apply skill **simple-english** exactly **once per file** written:
   - path: `.agents/skills/simple-english/SKILL.md`
   - mode: **pragmatic**
   - passes: **1** per file
6. Hand off to **frugal-eval** on every path written (do not claim create done).

## How

| piece | path |
|-------|------|
| YAML contract | `.agents/writer.yaml` |
| agent body (`.agents`) | `.agents/writer.md` |
| Grok spawn body | `.grok/agents/writer.md` |
| skill (**required**) | `.agents/skills/simple-english/` (also `.grok/skills/simple-english/`) |

Prefer `spawn_subagent` with `subagent_type: writer`, or in-process with the
same contract loaded.

### Card shape (default operator / cram — single file OK)

FILL IN → GOAL → TIME → YOU NEED → WHY → DO THIS → IF/THEN → NEXT.

### Learning topic shape (two files — default)

| File | Shape |
|------|--------|
| `TOPIC-principles.md` | definition → why → mechanism → map → critical misses → gotchas → critical tips → IF/THEN → do this |
| `TOPIC-references.md` | how to use → official table → gold-mine table → cross-stack → read order → gaps |

Copy from `Templates/topic-principles.md` and `Templates/topic-references.md`.

### STE pragmatic (1×) — skill-backed

- Procedural: imperative, ≤20 words/sentence, one instruction per sentence
- Descriptive: simple tenses, ≤25 words/sentence
- Active voice; ban should/would/may/might
- Condition before command; one word one meaning per file
- Never rewrite code, paths, commands, quoted errors

## After writer

Always: **frugal-eval** with **simple-english 3× hardcore**
(`rules/frugal-eval-mandatory.md`). That finishes create. Then git + mail for
full ship unless skip phrases (`create only`, `skip git`, `skip mail`, …).

**content_eval is not next.** Optional only if operator asks (`run content-eval`).

## Skip only if

- `skip ste` / `skip simple-english` / `skip writer ste` / `ship pipeline off`
- pure mechanical change (typo/path) with no teaching prose

## Do not

- Run frugal-eval’s 3× loop yourself (that is frugal-eval)
- Hand off without loading simple-english skill
- Ship first draft without STE 1× (unless skip phrase)
- Invent domain facts — mark `gap`
- Add content_eval as a required step after yourself
