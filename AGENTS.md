# Notes vault — agent rules

This is a **learning / operator notes** vault (not a live attack tree).

## study research pack (mandatory on every study topic)

Whenever you **create or expand study notes** for a course module, product topic, or learning unit (Associate modules, platform foundations, etc.):

### 1. Fetch official product docs (Claude / Anthropic when the course is Claude)

Use web search + open primary pages. Prefer:

- `support.claude.com` Help Center
- `platform.claude.com` / `docs.anthropic.com` platform docs
- `anthropic.com/engineering` and `anthropic.com/news` for mechanism-level posts
- Plan/UI limits: re-fetch (they change); never invent caps

Capture **links + one-line so-what** in the note under **Official Claude / Anthropic references** (or vendor-equivalent if the topic is not Claude).

### 2. Fetch gold-mine sources outside product docs

Also find **reputable, first-principles** material that is *not* a click-path UI tutorial:

| Prefer | Examples of sources |
|--------|---------------------|
| Vendor engineering blogs (mechanism) | Anthropic engineering, OpenAI engineering |
| Known practitioners | Simon Willison, Addy Osmani, similar long-form |
| Clear concept explainers | Context eng vs prompt eng, agent memory, tools |
| Avoid as sole authority | SEO listicles, anonymous “top 10 tips”, undated affiliate posts |

Add a dedicated section in every study note:

```markdown
## Gold-mine blogs (outside Claude product docs)
```

(or “outside &lt;vendor&gt; product docs”). Each row: link + why it is gold (mechanism, not hype).

### 3. Do not restrict examples to one vendor

Map concepts to **ChatGPT / Gemini / Grok / local agents** when the principle transfers (Projects ≈ sticky workspace, Skills ≈ procedures, Code exec ≈ verify math, Memory ≈ continuity).

### 4. Then content_eval 3-pass → git → mail

After research + draft:

1. **content_eval** three passes (`slop_chop` → `first_principles` → `core_questions`)
2. **git commit + push** study artifacts (never force-add `logs/`)
3. **email** PDF + markdown via pwnjournal SMTP (`send_report_email.py`) when the user wants mailouts (default: yes for study notes)

Skip research pack only if user says `skip research` / `course text only`.

## content quality (mandatory)

Whenever you **create, rewrite, expand, or polish** learning content here:

1. Draft the file (after research pack when it is a study topic).
2. Run **content_eval** three passes before finishing:
   - **pass 1** `slop_chop` — kill AI fluff, raise density
   - **pass 2** `first_principles` — beginner-clear mechanism + high-level map
   - **pass 3** `core_questions` — answer or surface clarifying gaps
3. Ship only on overall **SHIP**, or stop with **BLOCKED** + short questions.

Sources of truth for the loop:

| piece | path |
|-------|------|
| rule | `.grok/rules/content-eval-mandatory.md` |
| skill | `.grok/skills/content-eval/SKILL.md` → `/content-eval` |
| agent | `.grok/agents/content_eval.md` (`subagent_type: content_eval`) |
| study sources | this file § study research pack + `.grok/rules/study-sources-mandatory.md` |

Skip content_eval only if the user says `skip content-eval` / `raw dump ok`, or the change is mechanical (typo/path) with no teaching prose.

## tone for this vault

- frugal, copy-paste useful, just-in-time why
- first principles over tour-guide fluff
- authorized-testing scope only when discussing attacks
