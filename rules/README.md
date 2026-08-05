# rules/ — hard rules (canonical)

Single source of truth for this vault. **AGENTS.md** only points here.

| File | Job |
|------|-----|
| [ship-pipeline-mandatory.md](./ship-pipeline-mandatory.md) | content gen → eval 3× → git push → mail |
| [content-eval-mandatory.md](./content-eval-mandatory.md) | content_eval three-pass loop |
| [study-sources-mandatory.md](./study-sources-mandatory.md) | official docs + gold-mine blogs on study topics |

Grok also loads copies/symlinks under `.grok/rules/`. Edit files in **`rules/`** only.
