# rules/ — hard rules (canonical)

Single source of truth for this vault. **AGENTS.md** points here and hardcodes
agent names. Do not invent a parallel pipeline.

**Purpose reminder:** operator vault for bug bounty / architect / first
principles — not a university semester setup. See root `AGENTS.md`.

## Document create (default)

```text
writer (simple-english 1×) → frugal-eval (simple-english 3× hardcore)
```

| File | Job |
|------|-----|
| [ship-pipeline-mandatory.md](./ship-pipeline-mandatory.md) | Create + full ship; **simple-english only** on both agents |
| [writer-mandatory.md](./writer-mandatory.md) | **writer** + simple-english **1×** pragmatic |
| [frugal-eval-mandatory.md](./frugal-eval-mandatory.md) | **frugal-eval** + simple-english **3×** hardcore |
| [two-doc-ship-mandatory.md](./two-doc-ship-mandatory.md) | Learning notes = **2 PDFs** (shape, not extra eval) |
| [study-sources-mandatory.md](./study-sources-mandatory.md) | optional facts → Doc 2 only |
| [content-eval-mandatory.md](./content-eval-mandatory.md) | **optional** structure eval — only if operator asks (filename historic; not default create) |

## Agents + skills (hardcoded paths)

| Agent | YAML | Grok | Skill (required) |
|-------|------|------|------------------|
| writer | `.agents/writer.yaml` | `.grok/agents/writer.md` | **simple-english** 1× pragmatic |
| frugal-eval | `.agents/frugal-eval.yaml` | `.grok/agents/frugal-eval.md` | **simple-english** 3× hardcore |
| content_eval | — | `.grok/agents/content_eval.md` | content-eval (opt-in only) |

| Skill | Path |
|-------|------|
| **simple-english** (default language skill) | `.agents/skills/simple-english/` (+ `.grok/skills/simple-english` symlink) |
| content-eval | `.grok/skills/content-eval/` (optional) |

Board: [`.agents/README.md`](../.agents/README.md) · root [`AGENTS.md`](../AGENTS.md).

Grok loads copies/symlinks under `.grok/rules/`. **Edit files in `rules/` only.**
