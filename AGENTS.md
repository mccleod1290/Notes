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

**Document create uses the two-agent workflow below.**  
No phrase → writer + frugal-eval (both **simple-english**). Full ship adds git + mail.
Skip phrases: [`rules/ship-pipeline-mandatory.md`](rules/ship-pipeline-mandatory.md).

**Invoke (preferred):**

| How | What |
|-----|------|
| `/notes-ship` | Skill: create + PDF + git + mail |
| `/notes-create` | Skill: create only |
| `/workflow notes-ship {...}` | Orchestrated phases in `/workflows` |

Details: root [`README.md`](./README.md) · skill [`.grok/skills/notes-ship/SKILL.md`](.grok/skills/notes-ship/SKILL.md) · workflow [`.grok/workflows/notes-ship.rhai`](.grok/workflows/notes-ship.rhai).

---

## Document create workflow (core)

```text
1. WRITER        write once + simple-english 1× pragmatic
2. FRUGAL-EVAL   simple-english 3× hardcore (filter)
                 → create done
```

| Agent | Skill (required) | Passes | Mode |
|-------|------------------|--------|------|
| **writer** | **simple-english** | 1 | pragmatic |
| **frugal-eval** | **simple-english** | 3 | hardcore |

**Only language skill in the default path: simple-english.**  
Both agents **must** load `.agents/skills/simple-english/SKILL.md`.  
frugal-eval also loads `references/checklist.md`.

**content_eval is off by default** (optional: `run content-eval` / `structure eval`).

---

## Hard rules (canonical under `rules/`)

**Do not invent a longer create chain.** Read and obey:

| Rule | Path |
|------|------|
| **Ship pipeline** (create + delivery) | [`rules/ship-pipeline-mandatory.md`](rules/ship-pipeline-mandatory.md) |
| **writer** (draft + STE 1× pragmatic) | [`rules/writer-mandatory.md`](rules/writer-mandatory.md) |
| **frugal-eval** (STE hardcore 3×) | [`rules/frugal-eval-mandatory.md`](rules/frugal-eval-mandatory.md) |
| **Two-doc ship** (principles PDF + references PDF) | [`rules/two-doc-ship-mandatory.md`](rules/two-doc-ship-mandatory.md) |
| **Study research** (optional facts) | [`rules/study-sources-mandatory.md`](rules/study-sources-mandatory.md) |
| **content_eval** (optional only) | [`rules/content-eval-mandatory.md`](rules/content-eval-mandatory.md) |
| Index | [`rules/README.md`](rules/README.md) |

Harness auto-loads the same files via `.grok/rules/` (symlinks → `rules/`).

---

## Full ship (after create)

```text
0. RESEARCH (optional)   do not invent vendor facts
1. WRITER                simple-english 1× pragmatic
2. FRUGAL-EVAL           simple-english 3× hardcore
3. GIT                   commit + push origin
4. MAIL                  PDF + MD to study inbox
```

### Learning topics: two PDFs (shape only — still writer + frugal-eval)

| PDF | File | Job |
|-----|------|-----|
| **1** | `TOPIC-principles.md` | First principles, gotchas, **critical** tips (almost no URLs) |
| **2** | `TOPIC-references.md` | Official docs + gold-mine sources + so-what / extra tips |

Rule: [`rules/two-doc-ship-mandatory.md`](rules/two-doc-ship-mandatory.md).  
Templates: [`Templates/topic-principles.md`](Templates/topic-principles.md),
[`Templates/topic-references.md`](Templates/topic-references.md).

Chat-only delivery without git + mail is **incomplete** for full ship (unless
skip phrases / `create only`).

---

## HARDCODED agents (must use these names)

| Agent | Spawn | Contract (YAML) | Grok body | Skill | Passes | Mode | Default? |
|-------|-------|-----------------|-----------|-------|--------|------|----------|
| **writer** | `subagent_type: writer` | [`.agents/writer.yaml`](.agents/writer.yaml) | [`.grok/agents/writer.md`](.grok/agents/writer.md) | **simple-english** | **1** | pragmatic | **yes** |
| **frugal-eval** | `subagent_type: frugal-eval` | [`.agents/frugal-eval.yaml`](.agents/frugal-eval.yaml) | [`.grok/agents/frugal-eval.md`](.grok/agents/frugal-eval.md) | **simple-english** | **3** | **hardcore** | **yes** |
| content_eval | `subagent_type: content_eval` | — | [`.grok/agents/content_eval.md`](.grok/agents/content_eval.md) | content-eval | 3 | structure | **no** (opt-in) |

Also under `.agents/` as `.md` twins of the YAML contracts:
[`.agents/writer.md`](.agents/writer.md), [`.agents/frugal-eval.md`](.agents/frugal-eval.md).

Board: [`.agents/README.md`](.agents/README.md).

### Order is fixed

1. **writer** first (creates draft; **must** run simple-english once per file).
2. **frugal-eval** second (**must** run simple-english hardcore three times). Create done.
3. Git + mail for full ship.
4. content_eval only if operator explicitly asks.

Parent agents that write learning content **must** run writer → frugal-eval
(in-process or via spawn) before claiming create done.

---

## HARDCODED skills

| Skill | Path (canonical) | Also | Default create? |
|-------|------------------|------|-----------------|
| **simple-english** | [`.agents/skills/simple-english/`](.agents/skills/simple-english/) | [`.grok/skills/simple-english/`](.grok/skills/simple-english/) (symlink) | **yes — only language skill** |
| content-eval | [`.grok/skills/content-eval/`](.grok/skills/content-eval/) | `/content-eval` | no |

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
    content_eval.md        # spawn: content_eval (opt-in only)
  skills/
    simple-english/        # → ../../.agents/skills/simple-english
    content-eval/          # optional
  rules/                   # → ../../rules/*.md

rules/
  ship-pipeline-mandatory.md
  writer-mandatory.md
  frugal-eval-mandatory.md
  two-doc-ship-mandatory.md
  study-sources-mandatory.md
  content-eval-mandatory.md   # optional
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
