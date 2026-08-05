# Notes vault — agent rules (HARDCODED)

## Purpose (this vault)

**Personal** learning vault for the operator — not a university term plan, not a
classmate’s syllabus track, not “SVU agri setup.”

| Goal (in order) | What that means here |
|-----------------|----------------------|
| **Bug bounty / authorized pentest** | Operator batches, checklists, engagement notes, classification |
| **Become a security architect** | Systems thinking, threat models, design tradeoffs, depth over spray |
| **First principles** | Mechanism → map → practice; no tour-guide fluff |

One-off help notes (e.g. `agriculture/` for someone close — SVU agri ICT exam)
are **side folders only**. They do **not** redefine the vault purpose, pipeline
defaults, or agent examples. Do not treat “exam cram / semester term” as the
default product of this repo.

Learning / operator notes vault (not a live attack tree).

**Every keepable markdown deliverable uses the pipeline below.**  
No phrase → full pipeline. Skip only with phrases in
[`rules/ship-pipeline-mandatory.md`](rules/ship-pipeline-mandatory.md).

---

## Hard rules (canonical under `rules/`)

**Do not invent a shorter pipeline.** Read and obey:

| Rule | Path |
|------|------|
| **Ship pipeline** (full order) | [`rules/ship-pipeline-mandatory.md`](rules/ship-pipeline-mandatory.md) |
| **writer** (draft + STE 1× pragmatic) | [`rules/writer-mandatory.md`](rules/writer-mandatory.md) |
| **frugal-eval** (STE hardcore 3×) | [`rules/frugal-eval-mandatory.md`](rules/frugal-eval-mandatory.md) |
| **content_eval** (learning structure 3×) | [`rules/content-eval-mandatory.md`](rules/content-eval-mandatory.md) |
| **Study research pack** | [`rules/study-sources-mandatory.md`](rules/study-sources-mandatory.md) |
| Index | [`rules/README.md`](rules/README.md) |

Harness auto-loads the same files via `.grok/rules/` (symlinks → `rules/`).

---

## HARDCODED content pipeline

```text
0. STUDY RESEARCH   rules/study-sources-mandatory.md   (when expanding a learning topic)
1. WRITER           draft on disk + simple-english 1× pragmatic
2. FRUGAL-EVAL      simple-english 3× hardcore (strict + checklist)
3. CONTENT_EVAL     slop_chop → first_principles → core_questions
4. GIT              commit + push origin
5. MAIL             PDF + MD to study inbox
```

Chat-only delivery without git + mail is **incomplete** (unless skip phrases).

---

## HARDCODED agents (must use these names)

| Agent | Spawn | Contract (YAML) | Grok body | Skill | Passes | Mode |
|-------|-------|-----------------|-----------|-------|--------|------|
| **writer** | `subagent_type: writer` | [`.agents/writer.yaml`](.agents/writer.yaml) | [`.grok/agents/writer.md`](.grok/agents/writer.md) | simple-english | **1** | pragmatic |
| **frugal-eval** | `subagent_type: frugal-eval` | [`.agents/frugal-eval.yaml`](.agents/frugal-eval.yaml) | [`.grok/agents/frugal-eval.md`](.grok/agents/frugal-eval.md) | simple-english | **3** | **hardcore** |
| **content_eval** | `subagent_type: content_eval` | — | [`.grok/agents/content_eval.md`](.grok/agents/content_eval.md) | content-eval | **3** | structure lenses |

Also under `.agents/` as `.md` twins of the YAML contracts:
[`.agents/writer.md`](.agents/writer.md), [`.agents/frugal-eval.md`](.agents/frugal-eval.md).

Board: [`.agents/README.md`](.agents/README.md).

### Order is fixed

1. **writer** first (creates/edits draft; STE once).
2. **frugal-eval** second (same path; STE hardcore three times). Do not skip to content_eval while STE hardcore is open.
3. **content_eval** third (learning structure only — not a substitute for STE).
4. Then git, then mail.

Parent agents that write learning content **must** run this chain (in-process or via spawn) before claiming done.

---

## HARDCODED skills

| Skill | Path (canonical) | Also |
|-------|------------------|------|
| **simple-english** | [`.agents/skills/simple-english/`](.agents/skills/simple-english/) | [`.grok/skills/simple-english/`](.grok/skills/simple-english/) (symlink) |
| **content-eval** | [`.grok/skills/content-eval/`](.grok/skills/content-eval/) → `/content-eval` | — |

Source of simple-english: [AminBlg/SimpleEnglish](https://github.com/AminBlg/SimpleEnglish) (ASD-STE100).

| Who uses simple-english | Mode | Passes |
|-------------------------|------|--------|
| writer | pragmatic | 1 |
| frugal-eval | hardcore = strict + full `references/checklist.md` + fail-closed | 3 |

---

## Core topic folders (operator path)

Prefer writing under these when the goal is bug bounty / architect skill:

```text
AI/                 AI / MCP / LLM attack surface
api/                OWASP API operator batches
AEM/                Adobe Experience Manager
IIS/                IIS / .NET surfaces
web-app-testing/    web app attack classes
Checklists/         session + bug-class questions
Templates/          engagement / Obsidian
Understanding App/  first-principles app model
Mindset/            unstuck / operator discipline
Heat Mapping/       recon prioritization
```

`agriculture/` = **one-off favor** (SVU agri ICT help for someone close). Not a
core curriculum path. Do not use it as the default example for agents or rules.

---

## Directory map (do not relocate without updating this file)

```text
.agents/
  README.md
  writer.yaml              # canonical writer contract
  writer.md
  frugal-eval.yaml         # canonical frugal-eval contract
  frugal-eval.md
  skills/simple-english/   # STE skill + checklist + use-cases

.grok/
  agents/
    writer.md              # spawn: writer
    frugal-eval.md         # spawn: frugal-eval
    content_eval.md        # spawn: content_eval
  skills/
    simple-english/        # → ../../.agents/skills/simple-english
    content-eval/
  rules/                   # → ../../rules/*.md

rules/
  ship-pipeline-mandatory.md
  writer-mandatory.md
  frugal-eval-mandatory.md
  content-eval-mandatory.md
  study-sources-mandatory.md
  README.md
```

---

## Tone (hardcoded)

- frugal, copy-paste useful, just-in-time why
- first principles over tour-guide fluff
- Simple English on keepable prose (writer 1×, frugal-eval 3× hardcore)
- authorized-testing scope only when discussing attacks
- never invent domain facts — mark `gap`
- default audience = **you** (operator / future architect), not a university exam board
