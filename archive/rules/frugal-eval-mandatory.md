# HARD RULE: frugal-eval (simple-english hardcore 3×)

**Non-negotiable** second half of document create. After **writer**.
Pipeline: `rules/ship-pipeline-mandatory.md`.

## Create workflow

```text
writer (simple-english 1×)  →  frugal-eval (simple-english 3× hardcore)  →  create done
```

**Skill is mandatory.** Every frugal-eval run **must** load:

- `.agents/skills/simple-english/SKILL.md`
- `.agents/skills/simple-english/references/checklist.md`

No pass without the skill. Mode is always **hardcore** (not pragmatic).

## When

After any keepable learning draft is on disk (from writer or equivalent edit).
Also when the operator says: frugal eval, STE hardcore, 3x simple-english,
pre-ship language check.

## Must

1. Use agent **frugal-eval** (name is fixed).
2. **Read the file with tools** — never eval from memory.
3. Load skill **simple-english** and apply in **hardcore** mode **three**
   sequential times:

| Pass | Lens | Job |
|------|------|-----|
| 1 | mechanical | contractions, perfect tenses, banned modals, -ing clauses, semicolons, filler, trailing if/when, sentence length |
| 2 | structure | procedural vs descriptive, active voice, synonym lock, noun chains, warnings |
| 3 | checklist audit | full `.agents/skills/simple-english/references/checklist.md` (check mode) |

4. Mode **hardcore** = STE **strict** + full checklist + fail-closed.
   **Not** pragmatic (writer already did pragmatic).
5. FAIL → rewrite (max 2 per pass) → re-check that pass.
6. Overall **SHIP** | **REVISE** | **BLOCKED**. Write cleaned file on SHIP.
7. Create path ends on SHIP. Full ship continues: git → mail (unless skip /
   `create only`). **Do not** run content_eval unless operator asked.

## How

| piece | path |
|-------|------|
| YAML contract | `.agents/frugal-eval.yaml` |
| agent body (`.agents`) | `.agents/frugal-eval.md` |
| Grok spawn body | `.grok/agents/frugal-eval.md` |
| skill (**required**) | `.agents/skills/simple-english/SKILL.md` |
| checklist (**required**) | `.agents/skills/simple-english/references/checklist.md` |

Prefer `spawn_subagent` with `subagent_type: frugal-eval`, or in-process with
the same contract.

### Hardcore bars (fixed)

- Sentence limits: procedural ≤20, descriptive ≤25
- Modals: only can / will / must
- No present perfect, no progressive, no -ing verb clauses
- if/when before command; one locked term per concept
- No semicolons, no contractions; delete STE filler table hits
- Code / paths / flags / quoted errors untouchable
- Rubber-stamp all PASS with zero cuts is suspicious — justify
- Cite only rule numbers that exist in SKILL.md

## Skip only if

- `skip frugal-eval` / `no hardcore ste` / `skip ste` / `ship pipeline off`
- pure mechanical change (typo/path) with no teaching prose

## Do not

- Skip or merge the three passes into one skim
- Use pragmatic mode here
- Skip loading simple-english skill or checklist
- Auto-chain content_eval (optional only on request)
- Invent domain facts — mark `gap`
- Change code fences or quoted errors for style
