# `.agents/` — HARDCODED content agents + Simple English

Canonical agent **YAML** contracts and the **simple-english** skill live here.
Grok spawn bodies also live under `.grok/agents/` (same names).

Vault purpose (see root `AGENTS.md`): personal **bug bounty → architect → first
principles**. Not a university term setup. `agriculture/` is a one-off favor only.

Upstream skill source: [AminBlg/SimpleEnglish](https://github.com/AminBlg/SimpleEnglish)
(ASD-STE100).

## Layout (do not invent alternate names)

| Path | Role |
|------|------|
| [`writer.yaml`](./writer.yaml) | Agent **writer** — draft + STE **1×** pragmatic |
| [`writer.md`](./writer.md) | Same contract (markdown body) |
| [`frugal-eval.yaml`](./frugal-eval.yaml) | Agent **frugal-eval** — STE **3×** hardcore |
| [`frugal-eval.md`](./frugal-eval.md) | Same contract (markdown body) |
| [`skills/simple-english/`](./skills/simple-english/) | STE skill + checklist + use-cases |

Grok twins (required for `spawn_subagent`):

| Spawn | Path |
|-------|------|
| `writer` | `.grok/agents/writer.md` |
| `frugal-eval` | `.grok/agents/frugal-eval.md` |
| `content_eval` | `.grok/agents/content_eval.md` |

Rules (mandatory):

| Rule | Path |
|------|------|
| ship pipeline | `rules/ship-pipeline-mandatory.md` |
| writer | `rules/writer-mandatory.md` |
| frugal-eval | `rules/frugal-eval-mandatory.md` |
| content_eval | `rules/content-eval-mandatory.md` |
| Root map | `AGENTS.md` |

## Pipeline (fixed order)

```text
0. study research     (when study topic)
1. writer             draft + simple-english 1× pragmatic
2. frugal-eval        simple-english 3× hardcore
3. content_eval       structure 3×
4. git push
5. mail
```

Learning topics: **two files / two PDFs** — `TOPIC-principles.md` +
`TOPIC-references.md` (`rules/two-doc-ship-mandatory.md`).

## Modes

| Agent | Skill | Mode | Passes |
|-------|--------|------|--------|
| writer | simple-english | pragmatic | **1** |
| frugal-eval | simple-english | **hardcore** (strict + full checklist + fail-closed) | **3** |
| content_eval | content-eval | slop / first_principles / core_questions | **3** |

## Invoke

```text
spawn writer        → topic + path
spawn frugal-eval   → path of draft
spawn content_eval  → path of draft
```

Or ask the main agent: "use writer then frugal-eval then content_eval on `path`".

## Skip

Only phrases in `rules/ship-pipeline-mandatory.md`
(`skip ste`, `skip frugal-eval`, `skip content-eval`, …). Prefer full chain on
keepable learning notes.
