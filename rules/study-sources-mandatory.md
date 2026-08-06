# HARD RULE: study research pack

**Non-negotiable** when creating or expanding learning notes for this vault’s
purpose: **bug bounty / authorized pentest → security architect → first principles**.
Then run full ship pipeline (`rules/ship-pipeline-mandatory.md`).

This is **not** a university term / semester pack. One-off exam cram (e.g.
`agriculture/` SVU help) is exceptional; do not treat agri syllabus research as
the default research shape for the whole vault.

## When

HTB / Academy modules, vendor platforms (Claude, cloud, API frameworks), OWASP
and framework docs, AI/MCP surfaces, IIS/AEM/web operator packs — any learning
unit that builds **operator or architect** skill.

## Must fetch

### 1. Official product / standard docs

Prefer:

- Vendor docs and engineering blogs (mechanism, not marketing)
- OWASP, RFCs, and primary standards where the topic is security
- For Claude / agent courses: `support.claude.com`, `platform.claude.com` /
  `docs.anthropic.com`, `anthropic.com/engineering`, `anthropic.com/news`

Re-fetch plan/UI limits (they change). Never invent caps.

**Land every official link in Doc 2 only** (`TOPIC-references.md`), not inside
principles prose. Each row: link + what it teaches + operator so-what.

### 2. Gold-mine blogs outside official docs

Reputable first-principles sources (not click-path UI tutorials).

| Prefer | Avoid as sole authority |
|--------|-------------------------|
| Vendor engineering (mechanism) | SEO listicles |
| Simon Willison, PortSwigger Research, similar | Anonymous “top 10 tips” |
| Context eng / memory / tools explainers | Undated affiliate posts |
| Primary papers + writeups with repro steps | Undated “tips” with no evidence |

**Land gold-mine links in Doc 2 only.** Required section in
`TOPIC-references.md`:

```markdown
## Gold-mine first-principles sources
```

Each row: link + why gold + **extra tip from that source** (not a bare URL).

### 3. Cross-vendor / cross-stack map

Map principles to ChatGPT / Gemini / Grok / local agents when they transfer
(for tool/agent courses). For app security: map the same class across stacks
(e.g. BOLA on REST vs GraphQL). Skip if the domain has no transfer map.

Put the map table in **Doc 2**. If one transfer insight is **critical** to how
you work, also put a short tip (no URL required) in Doc 1 critical tips.

### Split (hard)

| Content | File |
|---------|------|
| Mechanism, gotchas, critical operator tips | `TOPIC-principles.md` |
| All external URLs + source so-whats | `TOPIC-references.md` |

See `rules/two-doc-ship-mandatory.md`. Do not paste research URLs into Doc 1
explanations.

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
