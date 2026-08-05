# HARD RULE: study research pack

**Non-negotiable** when creating or expanding study/course/platform notes.
Then run full ship pipeline (`rules/ship-pipeline-mandatory.md`).

## When

Associate modules, Claude/platform foundations, agriculture cram units, any
learning unit the operator is studying.

## Must fetch

### 1. Official product docs

For Claude courses prefer:

- `support.claude.com`
- `platform.claude.com` / `docs.anthropic.com`
- `anthropic.com/engineering` and `anthropic.com/news`

For other domains (e.g. agriculture): official syllabus, standards bodies,
extension services, peer-reviewed handbooks — never invent numbers or caps.

Re-fetch plan/UI limits (they change). Never invent caps.
Record links + one-line so-what under **Official … references**.

### 2. Gold-mine blogs outside product docs

Reputable first-principles sources (not click-path UI tutorials).

| Prefer | Avoid as sole authority |
|--------|-------------------------|
| Vendor engineering (mechanism) | SEO listicles |
| Simon Willison, Addy Osmani, similar | Anonymous “top 10 tips” |
| Context eng / memory / tools explainers | Undated affiliate posts |
| Domain extension / university notes (ag, etc.) | Undated “top 10 tips” farms |

Every study note must include:

```markdown
## Gold-mine blogs (outside official product docs)
```

(or outside that vendor’s / body’s official docs). Each row: link + why gold.

### 3. Cross-vendor map

Map principles to ChatGPT / Gemini / Grok / local agents when they transfer
(for tool/agent courses). Skip if domain has no cross-vendor map.

## Then (hardcoded pipeline)

```text
writer (simple-english 1× pragmatic)
  → frugal-eval (simple-english 3× hardcore)
  → content_eval 3×
  → git push
  → mail
```

See: `rules/writer-mandatory.md`, `rules/frugal-eval-mandatory.md`,
`rules/content-eval-mandatory.md`, `rules/ship-pipeline-mandatory.md`.

## Skip only if

`skip research` / `course text only`.
