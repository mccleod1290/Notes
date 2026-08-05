# HARD RULE: study research pack

**Non-negotiable** when creating or expanding study/course/platform notes.
Then run full ship pipeline (`rules/ship-pipeline-mandatory.md`).

## When

Associate modules, Claude/platform foundations, any learning unit the operator
is studying.

## Must fetch

### 1. Official product docs

For Claude courses prefer:

- `support.claude.com`
- `platform.claude.com` / `docs.anthropic.com`
- `anthropic.com/engineering` and `anthropic.com/news`

Re-fetch plan/UI limits (they change). Never invent caps.
Record links + one-line so-what under **Official … references**.

### 2. Gold-mine blogs outside product docs

Reputable first-principles sources (not click-path UI tutorials).

| Prefer | Avoid as sole authority |
|--------|-------------------------|
| Vendor engineering (mechanism) | SEO listicles |
| Simon Willison, Addy Osmani, similar | Anonymous “top 10 tips” |
| Context eng / memory / tools explainers | Undated affiliate posts |

Every study note must include:

```markdown
## Gold-mine blogs (outside Claude product docs)
```

(or outside that vendor’s product docs). Each row: link + why gold.

### 3. Cross-vendor map

Map principles to ChatGPT / Gemini / Grok / local agents when they transfer.

## Then

content_eval 3× → git push → mail.

## Skip only if

`skip research` / `course text only`.
