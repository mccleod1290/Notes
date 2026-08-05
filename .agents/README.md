# `.agents/` — writer + frugal-eval + Simple English

Content pipeline for this vault. Source of Simple English skill:
[AminBlg/SimpleEnglish](https://github.com/AminBlg/SimpleEnglish) (ASD-STE100).

## Layout

| Path | Role |
|------|------|
| [`skills/simple-english/`](./skills/simple-english/) | STE skill (pragmatic + strict rules) |
| [`writer.yaml`](./writer.yaml) | Agent **writer** — draft + STE **1×** pragmatic |
| [`frugal-eval.yaml`](./frugal-eval.yaml) | Agent **frugal-eval** — STE **3×** hardcore |

Grok also loads twins under [`.grok/agents/`](../.grok/agents/) so spawn works:

- `subagent_type: writer`
- `subagent_type: frugal-eval`

## Pipeline

```text
1. writer          draft on disk → simple-english 1× (pragmatic)
2. frugal-eval     same file     → simple-english 3× (hardcore / strict)
3. (optional)      content_eval  → learning structure (slop / first principles / core Qs)
4. ship            git push + mail per rules/ship-pipeline-mandatory.md
```

## Modes

| Agent | Skill | Mode | Passes |
|-------|--------|------|--------|
| writer | simple-english | pragmatic | **1** |
| frugal-eval | simple-english | **hardcore** (strict + full checklist + fail-closed) | **3** |

## Invoke

```text
# draft
spawn writer → topic + path

# gate
spawn frugal-eval → path of draft
```

Or ask the main agent: "use writer then frugal-eval on `path`".

## Skip

Only with explicit phrases from `rules/ship-pipeline-mandatory.md`
(e.g. `skip content-eval`, `raw dump ok`). Prefer not to skip STE hardcore
on keepable learning notes.
