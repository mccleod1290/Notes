# `.agents/` — HARDCODED content agents + Simple English

Canonical agent **YAML** contracts and the **simple-english** skill live here.
Grok spawn bodies also live under `.grok/agents/` (same names).

Vault purpose (see root `AGENTS.md`): personal **bug bounty → architect → first
principles**. Not a university term setup. `agriculture/` is a one-off favor only.

Upstream skill source: [AminBlg/SimpleEnglish](https://github.com/AminBlg/SimpleEnglish)
(ASD-STE100).

## Document create (default — only this)

```text
writer             draft + simple-english 1× pragmatic
  → frugal-eval    simple-english 3× hardcore
  → create done
```

Full ship after create: git push → mail.

**Both agents must use skill simple-english.** content_eval is opt-in only.

## Layout (do not invent alternate names)

| Path | Role |
|------|------|
| [`writer.yaml`](./writer.yaml) | Agent **writer** — draft + STE **1×** pragmatic |
| [`writer.md`](./writer.md) | Same contract (markdown body) |
| [`frugal-eval.yaml`](./frugal-eval.yaml) | Agent **frugal-eval** — STE **3×** hardcore |
| [`frugal-eval.md`](./frugal-eval.md) | Same contract (markdown body) |
| [`skills/simple-english/`](./skills/simple-english/) | STE skill + checklist + use-cases |

Grok twins (required for `spawn_subagent`):

| Spawn | Path | Default create? |
|-------|------|-----------------|
| `writer` | `.grok/agents/writer.md` | yes |
| `frugal-eval` | `.grok/agents/frugal-eval.md` | yes |
| `content_eval` | `.grok/agents/content_eval.md` | no (opt-in) |

Rules (mandatory):

| Rule | Path |
|------|------|
| ship pipeline | `rules/ship-pipeline-mandatory.md` |
| writer | `rules/writer-mandatory.md` |
| frugal-eval | `rules/frugal-eval-mandatory.md` |
| content_eval | `rules/content-eval-mandatory.md` (optional) |
| Root map | `AGENTS.md` |

## Modes

| Agent | Skill | Mode | Passes | Default? |
|-------|--------|------|--------|----------|
| writer | **simple-english** | pragmatic | **1** | yes |
| frugal-eval | **simple-english** | **hardcore** (strict + full checklist + fail-closed) | **3** | yes |
| content_eval | content-eval | structure | 3 | no |

## Invoke

```text
spawn writer        → topic + path
spawn frugal-eval   → path of draft
```

Or: "use writer then frugal-eval on `path`".

Learning topics: **two files** — `TOPIC-principles.md` + `TOPIC-references.md`
(`rules/two-doc-ship-mandatory.md`). Still only writer + frugal-eval.

## Skip

Phrases in `rules/ship-pipeline-mandatory.md`
(`skip ste`, `skip frugal-eval`, `create only`, …). Prefer full create chain
on keepable learning notes.
