# rules/ — hard rules (canonical)

Single source of truth for this vault. **AGENTS.md** only points here.

| File | Job |
|------|-----|
| [ship-pipeline-mandatory.md](./ship-pipeline-mandatory.md) | writer STE 1× → frugal-eval STE 3× hardcore → content_eval 3× → git → mail |
| [content-eval-mandatory.md](./content-eval-mandatory.md) | content_eval three-pass loop |
| [study-sources-mandatory.md](./study-sources-mandatory.md) | official docs + gold-mine blogs on study topics |

Content agents (YAML + skill): [`.agents/README.md`](../.agents/README.md).

Grok also loads copies/symlinks under `.grok/rules/`. Edit files in **`rules/`** only.
