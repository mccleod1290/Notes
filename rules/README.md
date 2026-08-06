# rules/ — hard rules (canonical)

Single source of truth for this vault. **AGENTS.md** points here and hardcodes
agent names. Do not invent a parallel pipeline.

**Purpose reminder:** operator vault for bug bounty / architect / first
principles — not a university semester setup. See root `AGENTS.md`.

| File | Job |
|------|-----|
| [ship-pipeline-mandatory.md](./ship-pipeline-mandatory.md) | Full order: research → writer → frugal-eval → content_eval → git → mail |
| [two-doc-ship-mandatory.md](./two-doc-ship-mandatory.md) | Learning notes = **2 PDFs**: principles/critical tips + references |
| [writer-mandatory.md](./writer-mandatory.md) | **writer** agent + simple-english **1×** pragmatic |
| [frugal-eval-mandatory.md](./frugal-eval-mandatory.md) | **frugal-eval** agent + simple-english **3×** hardcore |
| [content-eval-mandatory.md](./content-eval-mandatory.md) | **content_eval** structure 3× (after STE) |
| [study-sources-mandatory.md](./study-sources-mandatory.md) | official docs + gold-mine blogs → **Doc 2 only** |

## Agents + skills (hardcoded paths)

| Agent | YAML | Grok | Skill |
|-------|------|------|-------|
| writer | `.agents/writer.yaml` | `.grok/agents/writer.md` | simple-english 1× pragmatic |
| frugal-eval | `.agents/frugal-eval.yaml` | `.grok/agents/frugal-eval.md` | simple-english 3× hardcore |
| content_eval | — | `.grok/agents/content_eval.md` | content-eval 3× structure |

| Skill | Path |
|-------|------|
| simple-english | `.agents/skills/simple-english/` (+ `.grok/skills/simple-english` symlink) |
| content-eval | `.grok/skills/content-eval/` |

Board: [`.agents/README.md`](../.agents/README.md) · root [`AGENTS.md`](../AGENTS.md).

Grok loads copies/symlinks under `.grok/rules/`. **Edit files in `rules/` only.**
