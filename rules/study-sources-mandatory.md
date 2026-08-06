# Study research pack (facts — not a language agent)

**Not** a third create agent. Default create stays:

```text
writer (simple-english 1×) → frugal-eval (simple-english 3× hardcore)
```

Research supports **truth** so writer does not invent caps, APIs, or vendor
limits. Pipeline: `rules/ship-pipeline-mandatory.md`. Two-doc landing:
`rules/two-doc-ship-mandatory.md`.

Vault purpose: **bug bounty / authorized pentest → security architect → first
principles**. Not a university term track. `agriculture/` is exceptional.

## When to research

| Situation | Research? |
|-----------|-----------|
| Learning topic with vendor/product limits, APIs, plan caps | **Yes** — fetch; do not invent |
| Operator batch that only restates known DO THIS | Optional |
| Pure typo / path fix | No |
| Operator says `skip research` / `course text only` | Skip fetch |

Prefer research for HTB / Academy modules, vendor platforms (Claude, cloud,
API frameworks), OWASP, AI/MCP, IIS/AEM/web operator packs when the note
claims product truth.

## Must fetch (when researching)

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
`TOPIC-references.md` when you researched:

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

## Then (create + ship)

```text
writer (simple-english 1× pragmatic)
  → frugal-eval (simple-english 3× hardcore)   ← create done
  → git push → mail                            ← full ship
```

**Only skill for language agents: simple-english.** content_eval is optional
on request only — not in this path.

See: `rules/writer-mandatory.md`, `rules/frugal-eval-mandatory.md`,
`rules/ship-pipeline-mandatory.md`.

## Skip only if

`skip research` / `course text only`.
